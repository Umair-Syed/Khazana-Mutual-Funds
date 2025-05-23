part of 'fund_details_bloc.dart';

abstract class FundDetailsState extends Equatable {
  const FundDetailsState();

  @override
  List<Object> get props => [];
}

class FundDetailsInitial extends FundDetailsState {}

class FundDetailsLoading extends FundDetailsState {}

class FundDetailsLoaded extends FundDetailsState {
  final FundDetailsEntity fundDetails;
  final NavHistoryRange selectedTimeFrame;
  final List<NavPoint> filteredNavHistory;
  final double changeInTimeFrame;
  final double changePercentageInTimeFrame;

  const FundDetailsLoaded({
    required this.fundDetails,
    required this.selectedTimeFrame,
    required this.filteredNavHistory,
    required this.changeInTimeFrame,
    required this.changePercentageInTimeFrame,
  });

  @override
  List<Object> get props => [
    fundDetails,
    selectedTimeFrame,
    filteredNavHistory,
    changeInTimeFrame,
    changePercentageInTimeFrame,
  ];
}

class FundDetailsError extends FundDetailsState {
  final String message;

  const FundDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
