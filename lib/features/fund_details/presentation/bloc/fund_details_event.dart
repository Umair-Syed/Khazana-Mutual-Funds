part of 'fund_details_bloc.dart';

abstract class FundDetailsEvent extends Equatable {
  const FundDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadFundDetails extends FundDetailsEvent {
  final String fundId;

  const LoadFundDetails(this.fundId);

  @override
  List<Object> get props => [fundId];
}

class ChangeTimeFrame extends FundDetailsEvent {
  final NavHistoryRange timeFrame;

  const ChangeTimeFrame(this.timeFrame);

  @override
  List<Object> get props => [timeFrame];
}
