import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'fund_model.dart';

/// A helper class for loading and processing mutual fund data efficiently using isolates.
class FundDataHelper {
  static const String _dataPath = 'assets/data/funds.json';

  /// Cached data to avoid multiple loads
  static List<Fund>? _cachedFunds;

  /// Loads the full fund data using an isolate
  static Future<List<Fund>> _loadFullData() async {
    if (_cachedFunds != null) {
      return _cachedFunds!;
    }

    final jsonString = await rootBundle.loadString(_dataPath);

    // Use isolate to parse JSON without blocking the UI
    final fundsJson = await compute<String, List<dynamic>>(
      _parseJsonInIsolate,
      jsonString,
    );

    // Convert to Fund objects in an isolate
    final funds = await compute<List<dynamic>, List<Fund>>(
      (jsonList) => jsonList.map((json) => Fund.fromJson(json)).toList(),
      fundsJson,
    );

    _cachedFunds = funds;
    return funds;
  }

  /// Parses JSON in a separate isolate
  static List<dynamic> _parseJsonInIsolate(String jsonString) {
    return jsonDecode(jsonString) as List<dynamic>;
  }

  /// Returns a list of fund IDs and names
  static Future<List<Map<String, String>>> getFundsList() async {
    final funds = await _loadFullData();

    return await compute<List<Fund>, List<Map<String, String>>>(
      (funds) =>
          funds.map<Map<String, String>>((fund) {
            return {'id': fund.id, 'name': fund.name};
          }).toList(),
      funds,
    );
  }

  /// Returns NAV history for a specific fund within a time range
  static Future<List<NavPoint>> getNavHistory(
    String fundId,
    NavHistoryRange range,
  ) async {
    final funds = await _loadFullData();

    return await compute<Map<String, dynamic>, List<NavPoint>>((params) {
      final fundId = params['fundId'] as String;
      final range = params['range'] as NavHistoryRange;
      final funds = params['funds'] as List<Fund>;

      final fund = funds.firstWhere(
        (fund) => fund.id == fundId,
        orElse:
            () => Fund(
              id: '',
              name: '',
              meta: FundMeta(aum: 0, category: ''),
              navHistory: [],
              userHolding: UserHolding(
                investedAmount: 0,
                units: 0,
                purchaseNav: 0,
                lastPurchaseDate: DateTime.now(),
              ),
            ),
      );

      if (fund.id.isEmpty) {
        return [];
      }

      // Filter based on the time range
      if (range != NavHistoryRange.max) {
        final now = DateTime(
          2025,
          5,
          22,
        ); // Using the last date mentioned in README
        final cutoffDate = _getCutoffDate(now, range);

        return fund.navHistory.where((nav) {
          return nav.date.isAfter(cutoffDate) ||
              nav.date.isAtSameMomentAs(cutoffDate);
        }).toList();
      }

      return fund.navHistory;
    }, {'fundId': fundId, 'range': range, 'funds': funds});
  }

  /// Returns user holdings for a specific fund
  static Future<UserHolding?> getUserHolding(String fundId) async {
    final funds = await _loadFullData();

    return await compute<Map<String, dynamic>, UserHolding?>((params) {
      final fundId = params['fundId'] as String;
      final funds = params['funds'] as List<Fund>;

      try {
        final fund = funds.firstWhere((fund) => fund.id == fundId);
        return fund.userHolding;
      } catch (_) {
        return null;
      }
    }, {'fundId': fundId, 'funds': funds});
  }

  /// Returns today's (last) NAV for a specific fund
  static Future<double?> getTodayNav(String fundId) async {
    final funds = await _loadFullData();

    return await compute<Map<String, dynamic>, double?>((params) {
      final fundId = params['fundId'] as String;
      final funds = params['funds'] as List<Fund>;

      try {
        final fund = funds.firstWhere((fund) => fund.id == fundId);

        if (fund.navHistory.isEmpty) {
          return null;
        }

        return fund.navHistory.last.nav;
      } catch (_) {
        return null;
      }
    }, {'fundId': fundId, 'funds': funds});
  }

  /// Helper method to get cutoff date based on time range
  static DateTime _getCutoffDate(DateTime now, NavHistoryRange range) {
    switch (range) {
      case NavHistoryRange.oneMonth:
        return DateTime(now.year, now.month - 1, now.day);
      case NavHistoryRange.threeMonths:
        return DateTime(now.year, now.month - 3, now.day);
      case NavHistoryRange.sixMonths:
        return DateTime(now.year, now.month - 6, now.day);
      case NavHistoryRange.oneYear:
        return DateTime(now.year - 1, now.month, now.day);
      default:
        return DateTime(1900); // Return a very old date for MAX range
    }
  }
}

/// Enum for different NAV history time ranges
enum NavHistoryRange { oneMonth, threeMonths, sixMonths, oneYear, max }
