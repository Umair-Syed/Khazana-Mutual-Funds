import '../../domain/entities/fund_entity.dart';

class FundModel extends FundEntity {
  const FundModel({
    required super.id,
    required super.name,
    required super.category,
    required super.nav,
    required super.oneYearReturn,
    required super.threeYearReturn,
    required super.fiveYearReturn,
    required super.expenseRatio,
  });

  factory FundModel.fromFund(
    String id,
    String name,
    String category,
    double nav,
    double oneYearReturn,
    double threeYearReturn,
    double fiveYearReturn,
    double expenseRatio,
  ) {
    return FundModel(
      id: id,
      name: name,
      category: category,
      nav: nav,
      oneYearReturn: oneYearReturn,
      threeYearReturn: threeYearReturn,
      fiveYearReturn: fiveYearReturn,
      expenseRatio: expenseRatio,
    );
  }

  factory FundModel.fromFundOverview(
    String id,
    String name,
    String category,
    double nav,
    double oneYearReturn,
    double threeYearReturn,
    double fiveYearReturn,
    double expenseRatio,
  ) {
    return FundModel(
      id: id,
      name: name,
      category: category,
      nav: nav,
      oneYearReturn: oneYearReturn,
      threeYearReturn: threeYearReturn,
      fiveYearReturn: fiveYearReturn,
      expenseRatio: expenseRatio,
    );
  }
}
