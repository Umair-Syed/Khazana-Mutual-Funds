import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/index.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  SortOption? _currentSortOption;

  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(LoadWatchlists());
  }

  void _onSortChanged(SortOption option) {
    setState(() {
      _currentSortOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Watchlist'),
      ),
      body: BlocListener<WatchlistBloc, WatchlistState>(
        listener: (context, state) {
          if (state is WatchlistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const LoadingStateWidget();
            }

            if (state is WatchlistError) {
              return ErrorStateWidget(
                title: 'Error loading watchlists',
                message: state.message,
                onRetry:
                    () => context.read<WatchlistBloc>().add(LoadWatchlists()),
              );
            }

            if (state is WatchlistLoaded) {
              return _buildLoadedContent(state);
            }

            return const LoadingStateWidget();
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildLoadedContent(WatchlistLoaded state) {
    return Column(
      children: [
        if (state.watchlists.isNotEmpty)
          WatchlistTabs(
            watchlists: state.watchlists,
            selectedWatchlist: state.selectedWatchlist,
            onWatchlistSelected: (watchlistId) {
              context.read<WatchlistBloc>().add(
                SelectWatchlist(watchlistId: watchlistId),
              );
            },
          ),
        Expanded(
          child: WatchlistContent(
            selectedWatchlist: state.selectedWatchlist,
            fundOverviews: state.fundOverviews,
            isLoadingFundData: state.isLoadingFundData,
            currentSortOption: _currentSortOption,
            onSortChanged: _onSortChanged,
            onAddFund: _showAddFundModal,
            onRemoveFund: (fundId) => _removeFund(state, fundId),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showWatchlistBottomSheet,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      icon: const Icon(Icons.add),
      label: const Text(
        'Watchlist',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  void _removeFund(WatchlistLoaded state, String fundId) {
    if (state.selectedWatchlist != null) {
      context.read<WatchlistBloc>().add(
        RemoveFundFromWatchlistEvent(
          watchlistId: state.selectedWatchlist!.id,
          fundId: fundId,
        ),
      );
    }
  }

  void _showWatchlistBottomSheet() {
    final watchlistBloc = context.read<WatchlistBloc>();

    BlurredModalWrapper.show(
      context,
      child: BlocProvider.value(
        value: watchlistBloc,
        child: WatchlistBottomSheet(
          onCreateWatchlist: (name) {
            watchlistBloc.add(CreateWatchlistEvent(name: name));
          },
          onEditWatchlist: (id, name) {
            watchlistBloc.add(UpdateWatchlistNameEvent(id: id, name: name));
          },
          onDeleteWatchlist: _showDeleteConfirmation,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String watchlistId) {
    DeleteConfirmationDialog.show(
      context,
      title: 'Do you want to delete Watchlist?',
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        final watchlistBloc = context.read<WatchlistBloc>();
        watchlistBloc.add(DeleteWatchlistEvent(id: watchlistId));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Watchlist deleted successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    });
  }

  void _showAddFundModal() {
    final watchlistBloc = context.read<WatchlistBloc>();

    BlurredModalWrapper.show(
      context,
      child: BlocProvider.value(
        value: watchlistBloc,
        child: const AddFundModal(),
      ),
    );
  }
}
