import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/fund_entity.dart';
import '../../domain/usecases/get_all_funds.dart';

part 'fund_event.dart';
part 'fund_state.dart';

class FundBloc extends Bloc<FundEvent, FundState> {
  final GetAllFunds getAllFunds;

  FundBloc({required this.getAllFunds}) : super(FundInitial()) {
    on<LoadFunds>(_onLoadFunds);
  }

  Future<void> _onLoadFunds(LoadFunds event, Emitter<FundState> emit) async {
    emit(FundLoading());
    final failureOrFunds = await getAllFunds(NoParams());

    failureOrFunds.fold(
      (failure) => emit(FundError(_mapFailureToMessage(failure))),
      (funds) => emit(FundLoaded(funds)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server Failure';
      case CacheFailure _:
        return 'Cache Failure';
      case DataFailure _:
        return 'Data Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
