part of 'fund_bloc.dart';

abstract class FundState extends Equatable {
  const FundState();

  @override
  List<Object> get props => [];
}

class FundInitial extends FundState {}

class FundLoading extends FundState {}

class FundLoaded extends FundState {
  final List<FundEntity> funds;

  const FundLoaded(this.funds);

  @override
  List<Object> get props => [funds];
}

class FundError extends FundState {
  final String message;

  const FundError(this.message);

  @override
  List<Object> get props => [message];
}
