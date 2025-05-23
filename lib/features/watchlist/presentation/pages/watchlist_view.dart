import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/watchlist_tabs.dart';
import '../widgets/watchlist_content.dart';
import '../widgets/bottom_sheet/bottom_sheet.dart';
import 'dart:ui';

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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WatchlistError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading watchlists',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WatchlistBloc>().add(LoadWatchlists());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is WatchlistLoaded) {
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
                      onAddFund: () {
                        _showAddFundModal(context);
                      },
                      onRemoveFund: (fundId) {
                        if (state.selectedWatchlist != null) {
                          context.read<WatchlistBloc>().add(
                            RemoveFundFromWatchlistEvent(
                              watchlistId: state.selectedWatchlist!.id,
                              fundId: fundId,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }

            // Initial state or empty state
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWatchlistBottomSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text(
          'Watchlist',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void _showWatchlistBottomSheet(BuildContext context) {
    final watchlistBloc = context.read<WatchlistBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Blur backdrop
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
              // Bottom sheet content
              BlocProvider.value(
                value: watchlistBloc,
                child: Builder(
                  builder: (context) {
                    return WatchlistBottomSheet(
                      onCreateWatchlist: (name) {
                        watchlistBloc.add(CreateWatchlistEvent(name: name));
                      },
                      onEditWatchlist: (id, name) {
                        watchlistBloc.add(
                          UpdateWatchlistNameEvent(id: id, name: name),
                        );
                      },
                      onDeleteWatchlist: (id) {
                        _showDeleteConfirmation(context, id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String watchlistId) {
    final watchlistBloc = context.read<WatchlistBloc>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder:
          (context) => Dialog(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Do you want to delete Watchlist?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              watchlistBloc.add(
                                DeleteWatchlistEvent(id: watchlistId),
                              );

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Watchlist deleted successfully',
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showAddFundModal(BuildContext context) {
    final watchlistBloc = context.read<WatchlistBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlocProvider.value(
            value: watchlistBloc,
            child: _AddFundModalContent(),
          ),
    );
  }
}

class _AddFundModalContent extends StatefulWidget {
  @override
  State<_AddFundModalContent> createState() => _AddFundModalContentState();
}

class _AddFundModalContentState extends State<_AddFundModalContent> {
  late Future<List<dynamic>> _fundsFuture;
  List<dynamic> _allFunds = [];
  List<dynamic> _filteredFunds = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fundsFuture = _loadFunds();
  }

  Future<List<dynamic>> _loadFunds() async {
    // Get the current state to access available funds or load them
    final watchlistBloc = context.read<WatchlistBloc>();
    final currentState = watchlistBloc.state;

    if (currentState is WatchlistLoaded &&
        currentState.availableFunds.isNotEmpty) {
      _allFunds = currentState.availableFunds;
      _filteredFunds = _allFunds;
      return _allFunds;
    }

    // If no funds available, trigger loading and wait for the result
    watchlistBloc.add(LoadAvailableFunds());

    // Listen for state changes to get the loaded funds
    await for (final state in watchlistBloc.stream) {
      if (state is WatchlistLoaded && state.availableFunds.isNotEmpty) {
        _allFunds = state.availableFunds;
        _filteredFunds = _allFunds;
        return _allFunds;
      }
    }

    return [];
  }

  void _filterFunds(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredFunds = _allFunds;
      } else {
        _filteredFunds =
            _allFunds.where((fund) {
              return fund.name.toLowerCase().contains(query.toLowerCase());
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Mutual Funds',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for Mutual Funds, AMC, Fund Managers...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onChanged: _filterFunds,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fundsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading funds...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text('Error loading funds'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fundsFuture = _loadFunds();
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No funds available'));
                }

                if (_filteredFunds.isEmpty && _searchQuery.isNotEmpty) {
                  return const Center(
                    child: Text('No funds found matching your search'),
                  );
                }

                return BlocBuilder<WatchlistBloc, WatchlistState>(
                  builder: (context, state) {
                    return ListView.separated(
                      itemCount: _filteredFunds.length,
                      separatorBuilder:
                          (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: Theme.of(
                              context,
                            ).colorScheme.outlineVariant.withAlpha(100),
                          ),
                      itemBuilder: (context, index) {
                        final fund = _filteredFunds[index];
                        final isAdded =
                            state is WatchlistLoaded &&
                            (state.selectedWatchlist?.fundIds.contains(
                                  fund.id,
                                ) ??
                                false);

                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.account_balance,
                              color: Colors.black87,
                            ),
                          ),
                          title: Text(
                            fund.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            onPressed:
                                isAdded
                                    ? null
                                    : () {
                                      if (state is WatchlistLoaded &&
                                          state.selectedWatchlist != null) {
                                        context.read<WatchlistBloc>().add(
                                          AddFundToWatchlistEvent(
                                            watchlistId:
                                                state.selectedWatchlist!.id,
                                            fundId: fund.id,
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    },
                            icon: Icon(
                              isAdded
                                  ? Icons.bookmark_added_outlined
                                  : Icons.bookmark_add_outlined,
                              color:
                                  isAdded
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
