// MARK: - Fund
/// Model class for Mutual Fund data
class Fund {
  final String id;
  final String name;
  final FundMeta meta;
  final List<NavPoint> navHistory;
  final UserHolding userHolding;

  Fund({
    required this.id,
    required this.name,
    required this.meta,
    required this.navHistory,
    required this.userHolding,
  });

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      id: json['id'] as String,
      name: json['name'] as String,
      meta: FundMeta.fromJson(json['meta'] as Map<String, dynamic>),
      navHistory:
          (json['navHistory'] as List)
              .map((e) => NavPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
      userHolding: UserHolding.fromJson(
        json['userHolding'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'meta': meta.toJson(),
      'navHistory': navHistory.map((e) => e.toJson()).toList(),
      'userHolding': userHolding.toJson(),
    };
  }
}

// MARK: - FundMeta
/// Model class for fund metadata
class FundMeta {
  final double aum;
  final String category;

  FundMeta({required this.aum, required this.category});

  factory FundMeta.fromJson(Map<String, dynamic> json) {
    return FundMeta(
      aum: (json['aum'] as num).toDouble(),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'aum': aum, 'category': category};
  }
}

// MARK: - NavPoint
/// Model class for NAV data points
class NavPoint {
  final DateTime date;
  final double nav;

  NavPoint({required this.date, required this.nav});

  factory NavPoint.fromJson(Map<String, dynamic> json) {
    return NavPoint(
      date: DateTime.parse(json['date'] as String),
      nav: (json['nav'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String().split('T')[0], 'nav': nav};
  }
}

// MARK: - UserHolding
/// Model class for user holdings
class UserHolding {
  final double investedAmount;
  final double units;
  final double purchaseNav;
  final DateTime lastPurchaseDate;

  UserHolding({
    required this.investedAmount,
    required this.units,
    required this.purchaseNav,
    required this.lastPurchaseDate,
  });

  factory UserHolding.fromJson(Map<String, dynamic> json) {
    return UserHolding(
      investedAmount: (json['investedAmount'] as num).toDouble(),
      units: (json['units'] as num).toDouble(),
      purchaseNav: (json['purchaseNav'] as num).toDouble(),
      lastPurchaseDate: DateTime.parse(json['lastPurchaseDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'investedAmount': investedAmount,
      'units': units,
      'purchaseNav': purchaseNav,
      'lastPurchaseDate': lastPurchaseDate.toIso8601String().split('T')[0],
    };
  }
}
