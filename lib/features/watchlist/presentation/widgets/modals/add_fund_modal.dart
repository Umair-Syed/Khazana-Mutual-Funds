import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/watchlist_bloc.dart';
import '../../bloc/watchlist_event.dart';
import '../../bloc/watchlist_state.dart';

class AddFundModal extends StatefulWidget {
  const AddFundModal({super.key});

  @override
  State<AddFundModal> createState() => _AddFundModalState();
}

class _AddFundModalState extends State<AddFundModal> {
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
    final watchlistBloc = context.read<WatchlistBloc>();
    final currentState = watchlistBloc.state;

    if (currentState is WatchlistLoaded &&
        currentState.availableFunds.isNotEmpty) {
      _allFunds = currentState.availableFunds;
      _filteredFunds = _allFunds;
      return _allFunds;
    }

    watchlistBloc.add(LoadAvailableFunds());

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
          _buildHandle(),
          _buildHeader(),
          _buildSearchField(),
          const SizedBox(height: 16),
          Expanded(child: _buildFundsList()),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
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
    );
  }

  Widget _buildSearchField() {
    return Padding(
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
    );
  }

  Widget _buildFundsList() {
    return FutureBuilder<List<dynamic>>(
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
                const Text('Error loading funds'),
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
                    (state.selectedWatchlist?.fundIds.contains(fund.id) ??
                        false);

                return FundListTile(
                  fund: fund,
                  isAdded: isAdded,
                  onAdd: () {
                    if (state is WatchlistLoaded &&
                        state.selectedWatchlist != null) {
                      context.read<WatchlistBloc>().add(
                        AddFundToWatchlistEvent(
                          watchlistId: state.selectedWatchlist!.id,
                          fundId: fund.id,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class FundListTile extends StatelessWidget {
  final dynamic fund;
  final bool isAdded;
  final VoidCallback? onAdd;

  const FundListTile({
    super.key,
    required this.fund,
    required this.isAdded,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.account_balance, color: Colors.black87),
      ),
      title: Text(
        fund.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: IconButton(
        onPressed: isAdded ? null : onAdd,
        icon: Icon(
          isAdded ? Icons.bookmark_added_outlined : Icons.bookmark_add_outlined,
          color:
              isAdded
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
