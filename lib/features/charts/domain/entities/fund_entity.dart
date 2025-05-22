import 'package:equatable/equatable.dart';

class FundEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final double nav;
  final double oneYearReturn;
  final double threeYearReturn;
  final double fiveYearReturn;
  final double expenseRatio;

  const FundEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.nav,
    required this.oneYearReturn,
    required this.threeYearReturn,
    required this.fiveYearReturn,
    required this.expenseRatio,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    nav,
    oneYearReturn,
    threeYearReturn,
    fiveYearReturn,
    expenseRatio,
  ];
}
