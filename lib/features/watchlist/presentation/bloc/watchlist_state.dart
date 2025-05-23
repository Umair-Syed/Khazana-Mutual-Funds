import 'package:equatable/equatable.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../domain/entities/watchlist_fund_entity.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistEntity> watchlists;
  final WatchlistEntity? selectedWatchlist;
  final List<WatchlistFundEntity> availableFunds;
  final List<WatchlistFundEntity> filteredFunds;
  final String searchQuery;
  final Map<String, FundOverView> fundOverviews;
  final bool isLoadingFundData;

  const WatchlistLoaded({
    required this.watchlists,
    this.selectedWatchlist,
    this.availableFunds = const [],
    this.filteredFunds = const [],
    this.searchQuery = '',
    this.fundOverviews = const {},
    this.isLoadingFundData = false,
  });

  WatchlistLoaded copyWith({
    List<WatchlistEntity>? watchlists,
    WatchlistEntity? selectedWatchlist,
    List<WatchlistFundEntity>? availableFunds,
    List<WatchlistFundEntity>? filteredFunds,
    String? searchQuery,
    Map<String, FundOverView>? fundOverviews,
    bool? isLoadingFundData,
    bool clearSelectedWatchlist = false,
  }) {
    return WatchlistLoaded(
      watchlists: watchlists ?? this.watchlists,
      selectedWatchlist:
          clearSelectedWatchlist
              ? null
              : (selectedWatchlist ?? this.selectedWatchlist),
      availableFunds: availableFunds ?? this.availableFunds,
      filteredFunds: filteredFunds ?? this.filteredFunds,
      searchQuery: searchQuery ?? this.searchQuery,
      fundOverviews: fundOverviews ?? this.fundOverviews,
      isLoadingFundData: isLoadingFundData ?? this.isLoadingFundData,
    );
  }

  @override
  List<Object?> get props => [
    watchlists,
    selectedWatchlist,
    availableFunds,
    filteredFunds,
    searchQuery,
    fundOverviews,
    isLoadingFundData,
  ];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError({required this.message});

  @override
  List<Object?> get props => [message];
}

class WatchlistOperationSuccess extends WatchlistState {
  final String message;

  const WatchlistOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
