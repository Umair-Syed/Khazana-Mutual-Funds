part of 'fund_bloc.dart';

abstract class FundEvent extends Equatable {
  const FundEvent();

  @override
  List<Object> get props => [];
}

class LoadFunds extends FundEvent {
  const LoadFunds();
}
