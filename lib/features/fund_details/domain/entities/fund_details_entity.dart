import 'package:equatable/equatable.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart';

class FundDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final List<NavPoint> navHistory;
  final UserHolding userHolding;
  final double currentNav;
  final double oneDayChange;
  final double oneDayChangePercentage;

  const FundDetailsEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.navHistory,
    required this.userHolding,
    required this.currentNav,
    required this.oneDayChange,
    required this.oneDayChangePercentage,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    navHistory,
    userHolding,
    currentNav,
    oneDayChange,
    oneDayChangePercentage,
  ];
}
