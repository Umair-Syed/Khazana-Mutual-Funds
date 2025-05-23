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

  /// Returns an overview of a specific fund with performance metrics
  static Future<FundOverView> getFundOverView(String fundId) async {
    final funds = await _loadFullData();

    return await compute<Map<String, dynamic>, FundOverView>((params) {
      final fundId = params['fundId'] as String;
      final funds = params['funds'] as List<Fund>;

      // Find the fund by ID
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

      if (fund.id.isEmpty || fund.navHistory.isEmpty) {
        return FundOverView(
          id: fundId,
          name: 'Not Found',
          category: 'N/A',
          nav: 0,
          oneYearReturn: 0,
          threeYearReturn: 0,
          fiveYearReturn: 0,
        );
      }

      return _calculateFundOverview(fund);
    }, {'fundId': fundId, 'funds': funds});
  }

  /// Returns overview for all funds
  static Future<List<FundOverView>> getAllFundsOverview() async {
    final funds = await _loadFullData();

    return await compute<List<Fund>, List<FundOverView>>(
      (funds) => funds.map((fund) => _calculateFundOverview(fund)).toList(),
      funds,
    );
  }

  /// Helper method to calculate fund overview metrics
  static FundOverView _calculateFundOverview(Fund fund) {
    if (fund.navHistory.isEmpty) {
      return FundOverView(
        id: fund.id,
        name: fund.name,
        category: fund.meta.category,
        nav: 0,
        oneYearReturn: 0,
        threeYearReturn: 0,
        fiveYearReturn: 0,
      );
    }

    // Get current NAV (last date's NAV)
    final currentNav = fund.navHistory.last.nav;
    final lastDate = fund.navHistory.last.date;

    // Find NAVs for comparison periods or use first NAV if not available
    final firstNav = fund.navHistory.first.nav;

    // Find NAV from 1 year ago
    final oneYearAgoDate = DateTime(
      lastDate.year - 1,
      lastDate.month,
      lastDate.day,
    );
    NavPoint? oneYearAgoNavPoint = _findClosestNavPoint(
      fund.navHistory,
      oneYearAgoDate,
    );
    final oneYearAgoNav = oneYearAgoNavPoint?.nav ?? firstNav;

    // Find NAV from 3 years ago
    final threeYearsAgoDate = DateTime(
      lastDate.year - 3,
      lastDate.month,
      lastDate.day,
    );
    NavPoint? threeYearsAgoNavPoint = _findClosestNavPoint(
      fund.navHistory,
      threeYearsAgoDate,
    );
    final threeYearsAgoNav = threeYearsAgoNavPoint?.nav ?? firstNav;

    // Find NAV from 5 years ago
    final fiveYearsAgoDate = DateTime(
      lastDate.year - 5,
      lastDate.month,
      lastDate.day,
    );
    NavPoint? fiveYearsAgoNavPoint = _findClosestNavPoint(
      fund.navHistory,
      fiveYearsAgoDate,
    );
    final fiveYearsAgoNav = fiveYearsAgoNavPoint?.nav ?? firstNav;

    // Calculate returns as percentages
    final oneYearReturn = ((currentNav - oneYearAgoNav) / oneYearAgoNav) * 100;
    final threeYearReturn =
        ((currentNav - threeYearsAgoNav) / threeYearsAgoNav) * 100;
    final fiveYearReturn =
        ((currentNav - fiveYearsAgoNav) / fiveYearsAgoNav) * 100;

    return FundOverView(
      id: fund.id,
      name: fund.name,
      category: fund.meta.category,
      nav: currentNav,
      oneYearReturn: oneYearReturn,
      threeYearReturn: threeYearReturn,
      fiveYearReturn: fiveYearReturn,
    );
  }

  /// Helper method to find the closest NAV point to a given date
  static NavPoint? _findClosestNavPoint(
    List<NavPoint> navHistory,
    DateTime targetDate,
  ) {
    // If history is empty, return null
    if (navHistory.isEmpty) return null;

    // Check if target date is before first nav point
    if (targetDate.isBefore(navHistory.first.date)) return null;

    // Try to find exact match or closest previous date
    NavPoint? closestNavPoint;

    for (final navPoint in navHistory) {
      // If we find exact match, return it
      if (navPoint.date.year == targetDate.year &&
          navPoint.date.month == targetDate.month &&
          navPoint.date.day == targetDate.day) {
        return navPoint;
      }

      // If this nav point is before or on target date, it's a candidate
      if (navPoint.date.isBefore(targetDate) ||
          navPoint.date.isAtSameMomentAs(targetDate)) {
        // If we don't have a closest yet, or this one is closer, update
        if (closestNavPoint == null ||
            navPoint.date.isAfter(closestNavPoint.date)) {
          closestNavPoint = navPoint;
        }
      }
    }

    return closestNavPoint;
  }

  static Future<Fund> getFundsAllDataFromId(String fundId) async {
    final funds = await _loadFullData();

    return await compute<Map<String, dynamic>, Fund>((params) {
      final fundId = params['fundId'] as String;
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

      return fund;
    }, {'fundId': fundId, 'funds': funds});
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
enum NavHistoryRange {
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  threeYear,
  max,
}
