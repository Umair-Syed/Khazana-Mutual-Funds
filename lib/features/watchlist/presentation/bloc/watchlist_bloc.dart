import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../../../../core/utils/funds_data_utils/fund_data_helper.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../domain/usecases/get_all_watchlists.dart';
import '../../domain/usecases/create_watchlist.dart';
import '../../domain/usecases/delete_watchlist.dart';
import '../../domain/usecases/update_watchlist_name.dart';
import '../../domain/usecases/add_fund_to_watchlist.dart';
import '../../domain/usecases/remove_fund_from_watchlist.dart';
import '../../domain/usecases/get_available_funds.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetAllWatchlists getAllWatchlists;
  final CreateWatchlist createWatchlist;
  final DeleteWatchlist deleteWatchlist;
  final UpdateWatchlistName updateWatchlistName;
  final AddFundToWatchlist addFundToWatchlist;
  final RemoveFundFromWatchlist removeFundFromWatchlist;
  final GetAvailableFunds getAvailableFunds;

  WatchlistBloc({
    required this.getAllWatchlists,
    required this.createWatchlist,
    required this.deleteWatchlist,
    required this.updateWatchlistName,
    required this.addFundToWatchlist,
    required this.removeFundFromWatchlist,
    required this.getAvailableFunds,
  }) : super(WatchlistInitial()) {
    on<LoadWatchlists>(_onLoadWatchlists);
    on<CreateWatchlistEvent>(_onCreateWatchlist);
    on<SelectWatchlist>(_onSelectWatchlist);
    on<UpdateWatchlistNameEvent>(_onUpdateWatchlistName);
    on<DeleteWatchlistEvent>(_onDeleteWatchlist);
    on<AddFundToWatchlistEvent>(_onAddFundToWatchlist);
    on<RemoveFundFromWatchlistEvent>(_onRemoveFundFromWatchlist);
    on<LoadAvailableFunds>(_onLoadAvailableFunds);
    on<SearchFunds>(_onSearchFunds);
    on<LoadWatchlistFundData>(_onLoadWatchlistFundData);
  }

  Future<void> _onLoadWatchlists(
    LoadWatchlists event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoading());

    final result = await getAllWatchlists(NoParams());

    result.fold((failure) => emit(WatchlistError(message: failure.message)), (
      watchlists,
    ) {
      WatchlistEntity? selectedWatchlist;
      if (watchlists.isNotEmpty) {
        selectedWatchlist = watchlists.first;
      }

      emit(
        WatchlistLoaded(
          watchlists: watchlists,
          selectedWatchlist: selectedWatchlist,
        ),
      );

      // Load fund data for the selected watchlist if it exists
      if (selectedWatchlist != null) {
        add(LoadWatchlistFundData(watchlistId: selectedWatchlist.id));
      }
    });
  }

  Future<void> _onCreateWatchlist(
    CreateWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      emit(WatchlistLoading());

      final result = await createWatchlist(
        CreateWatchlistParams(name: event.name),
      );

      result.fold((failure) => emit(WatchlistError(message: failure.message)), (
        newWatchlist,
      ) {
        // Trigger reload of watchlists
        add(LoadWatchlists());
      });
    }
  }

  Future<void> _onSelectWatchlist(
    SelectWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      final selectedWatchlist = currentState.watchlists.firstWhere(
        (watchlist) => watchlist.id == event.watchlistId,
      );

      emit(currentState.copyWith(selectedWatchlist: selectedWatchlist));

      // Load fund data for the selected watchlist
      add(LoadWatchlistFundData(watchlistId: event.watchlistId));
    }
  }

  Future<void> _onUpdateWatchlistName(
    UpdateWatchlistNameEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      emit(WatchlistLoading());

      final result = await updateWatchlistName(
        UpdateWatchlistNameParams(id: event.id, name: event.name),
      );

      result.fold((failure) => emit(WatchlistError(message: failure.message)), (
        updatedWatchlist,
      ) {
        // Trigger reload of watchlists
        add(LoadWatchlists());
      });
    }
  }

  Future<void> _onDeleteWatchlist(
    DeleteWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      emit(WatchlistLoading());

      final result = await deleteWatchlist(DeleteWatchlistParams(id: event.id));

      result.fold((failure) => emit(WatchlistError(message: failure.message)), (
        _,
      ) {
        // Trigger reload of watchlists
        add(LoadWatchlists());
      });
    }
  }

  Future<void> _onAddFundToWatchlist(
    AddFundToWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      final result = await addFundToWatchlist(
        AddFundToWatchlistParams(
          watchlistId: event.watchlistId,
          fundId: event.fundId,
        ),
      );

      result.fold((failure) => emit(WatchlistError(message: failure.message)), (
        updatedWatchlist,
      ) {
        // Trigger reload of watchlists
        add(LoadWatchlists());
      });
    }
  }

  Future<void> _onRemoveFundFromWatchlist(
    RemoveFundFromWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      final result = await removeFundFromWatchlist(
        RemoveFundFromWatchlistParams(
          watchlistId: event.watchlistId,
          fundId: event.fundId,
        ),
      );

      result.fold((failure) => emit(WatchlistError(message: failure.message)), (
        updatedWatchlist,
      ) {
        // Trigger reload of watchlists
        add(LoadWatchlists());
      });
    }
  }

  Future<void> _onLoadAvailableFunds(
    LoadAvailableFunds event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;

      final result = await getAvailableFunds(NoParams());

      result.fold(
        (failure) => emit(WatchlistError(message: failure.message)),
        (funds) => emit(
          currentState.copyWith(availableFunds: funds, filteredFunds: funds),
        ),
      );
    }
  }

  Future<void> _onSearchFunds(
    SearchFunds event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;

      final filteredFunds =
          currentState.availableFunds
              .where(
                (fund) =>
                    fund.name.toLowerCase().contains(event.query.toLowerCase()),
              )
              .toList();

      emit(
        currentState.copyWith(
          filteredFunds: filteredFunds,
          searchQuery: event.query,
        ),
      );
    }
  }

  Future<void> _onLoadWatchlistFundData(
    LoadWatchlistFundData event,
    Emitter<WatchlistState> emit,
  ) async {
    if (state is WatchlistLoaded) {
      final currentState = state as WatchlistLoaded;
      final watchlist = currentState.watchlists.firstWhere(
        (w) => w.id == event.watchlistId,
        orElse: () => currentState.selectedWatchlist!,
      );

      if (watchlist.fundIds.isEmpty) {
        return;
      }

      // Show loading state for fund data
      emit(currentState.copyWith(isLoadingFundData: true));

      try {
        final Map<String, FundOverView> fundOverviews = Map.from(
          currentState.fundOverviews,
        );

        // Load fund data for all funds in the watchlist
        for (final fundId in watchlist.fundIds) {
          // Skip if already loaded
          if (!fundOverviews.containsKey(fundId)) {
            final overview = await FundDataHelper.getFundOverView(fundId);
            fundOverviews[fundId] = overview;
          }
        }

        emit(
          currentState.copyWith(
            fundOverviews: fundOverviews,
            isLoadingFundData: false,
          ),
        );
      } catch (e) {
        emit(
          WatchlistError(message: 'Failed to load fund data: ${e.toString()}'),
        );
      }
    }
  }
}
