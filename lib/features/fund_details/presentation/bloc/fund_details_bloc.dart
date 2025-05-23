import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/funds_data_utils/fund_data_helper.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart';
import '../../domain/entities/fund_details_entity.dart';
import '../../domain/usecases/get_fund_details.dart';

part 'fund_details_event.dart';
part 'fund_details_state.dart';

class FundDetailsBloc extends Bloc<FundDetailsEvent, FundDetailsState> {
  final GetFundDetails getFundDetails;

  FundDetailsBloc({required this.getFundDetails})
    : super(FundDetailsInitial()) {
    on<LoadFundDetails>(_onLoadFundDetails);
    on<ChangeTimeFrame>(_onChangeTimeFrame);
  }

  Future<void> _onLoadFundDetails(
    LoadFundDetails event,
    Emitter<FundDetailsState> emit,
  ) async {
    emit(FundDetailsLoading());
    final result = await getFundDetails(FundParams(fundId: event.fundId));

    result.fold(
      (failure) => emit(FundDetailsError(_mapFailureToMessage(failure))),
      (fundDetails) {
        // Default to 1 month time frame
        final timeFrame = NavHistoryRange.oneMonth;
        final filteredNavHistory = _getFilteredNavHistory(
          fundDetails.navHistory,
          timeFrame,
        );

        final changeInfo = _calculateChangeInTimeFrame(filteredNavHistory);

        emit(
          FundDetailsLoaded(
            fundDetails: fundDetails,
            selectedTimeFrame: timeFrame,
            filteredNavHistory: filteredNavHistory,
            changeInTimeFrame: changeInfo.change,
            changePercentageInTimeFrame: changeInfo.percentage,
          ),
        );
      },
    );
  }

  Future<void> _onChangeTimeFrame(
    ChangeTimeFrame event,
    Emitter<FundDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is FundDetailsLoaded) {
      final filteredNavHistory = _getFilteredNavHistory(
        currentState.fundDetails.navHistory,
        event.timeFrame,
      );

      final changeInfo = _calculateChangeInTimeFrame(filteredNavHistory);

      emit(
        FundDetailsLoaded(
          fundDetails: currentState.fundDetails,
          selectedTimeFrame: event.timeFrame,
          filteredNavHistory: filteredNavHistory,
          changeInTimeFrame: changeInfo.change,
          changePercentageInTimeFrame: changeInfo.percentage,
        ),
      );
    }
  }

  List<NavPoint> _getFilteredNavHistory(
    List<NavPoint> fullHistory,
    NavHistoryRange range,
  ) {
    if (fullHistory.isEmpty) return [];
    if (range == NavHistoryRange.max) return fullHistory;

    final lastDate = fullHistory.last.date;
    DateTime cutoffDate;

    switch (range) {
      case NavHistoryRange.oneMonth:
        cutoffDate = DateTime(lastDate.year, lastDate.month - 1, lastDate.day);
        break;
      case NavHistoryRange.threeMonths:
        cutoffDate = DateTime(lastDate.year, lastDate.month - 3, lastDate.day);
        break;
      case NavHistoryRange.sixMonths:
        cutoffDate = DateTime(lastDate.year, lastDate.month - 6, lastDate.day);
        break;
      case NavHistoryRange.oneYear:
        cutoffDate = DateTime(lastDate.year - 1, lastDate.month, lastDate.day);
        break;
      case NavHistoryRange.threeYear:
        cutoffDate = DateTime(lastDate.year - 3, lastDate.month, lastDate.day);
        break;
      default:
        cutoffDate = DateTime(1900); // Very old date to include all history
    }

    return fullHistory.where((navPoint) {
      return navPoint.date.isAfter(cutoffDate) ||
          navPoint.date.isAtSameMomentAs(cutoffDate);
    }).toList();
  }

  ({double change, double percentage}) _calculateChangeInTimeFrame(
    List<NavPoint> navHistory,
  ) {
    if (navHistory.isEmpty || navHistory.length == 1) {
      return (change: 0, percentage: 0);
    }

    final firstNav = navHistory.first.nav;
    final lastNav = navHistory.last.nav;
    final change = lastNav - firstNav;
    final percentage = (change / firstNav) * 100;

    return (change: change, percentage: percentage);
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
