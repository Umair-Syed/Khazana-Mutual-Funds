import 'package:flutter/material.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart';
import 'watchlist_fund_item.dart';

enum SortOption { title, nav }

class WatchlistContent extends StatelessWidget {
  final WatchlistEntity? selectedWatchlist;
  final VoidCallback onAddFund;
  final Function(String) onRemoveFund;
  final Map<String, FundOverView> fundOverviews;
  final bool isLoadingFundData;
  final SortOption? currentSortOption;
  final Function(SortOption)? onSortChanged;

  const WatchlistContent({
    super.key,
    required this.selectedWatchlist,
    required this.onAddFund,
    required this.onRemoveFund,
    this.fundOverviews = const {},
    this.isLoadingFundData = false,
    this.currentSortOption,
    this.onSortChanged,
  });

  List<String> _getSortedFundIds() {
    if (selectedWatchlist == null || currentSortOption == null) {
      return selectedWatchlist?.fundIds ?? [];
    }

    final fundIds = List<String>.from(selectedWatchlist!.fundIds);

    switch (currentSortOption!) {
      case SortOption.title:
        fundIds.sort((a, b) {
          final fundA = fundOverviews[a];
          final fundB = fundOverviews[b];
          if (fundA == null || fundB == null) return 0;
          return fundA.name.compareTo(fundB.name);
        });
        break;
      case SortOption.nav:
        fundIds.sort((a, b) {
          final fundA = fundOverviews[a];
          final fundB = fundOverviews[b];
          if (fundA == null || fundB == null) return 0;
          return (fundB.nav).compareTo(fundA.nav);
        });
        break;
    }

    return fundIds;
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      Text(
                        'Sort by',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                _buildSortOption(
                  context,
                  'Title',
                  'Sort alphabetically by fund name',
                  SortOption.title,
                  Icons.sort_by_alpha,
                ),
                _buildSortOption(
                  context,
                  'NAV',
                  'Sort by Net Asset Value (highest first)',
                  SortOption.nav,
                  Icons.trending_up,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    String subtitle,
    SortOption option,
    IconData icon,
  ) {
    final isSelected = currentSortOption == option;

    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      trailing:
          isSelected
              ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
              : null,
      onTap: () {
        onSortChanged?.call(option);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedWatchlist == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Your watchlist is empty',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add mutual funds to track their performance.\nAdd a watchlist to group them together.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withAlpha(180),
              ),
            ),
          ],
        ),
      );
    }

    if (selectedWatchlist!.fundIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.query_stats_outlined,
              size: 80,
              weight: 30,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'Looks like your watchlist is empty.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddFund,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              label: Text(
                'Add Mutual Funds',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final sortedFundIds = _getSortedFundIds();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: onAddFund,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Add',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showSortBottomSheet(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sort',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child:
              isLoadingFundData
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: sortedFundIds.length,
                    itemBuilder: (context, index) {
                      final fundId = sortedFundIds[index];

                      return Dismissible(
                        key: Key(fundId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onDismissed: (direction) {
                          onRemoveFund(fundId);
                        },
                        child: WatchlistFundItem(
                          fundId: fundId,
                          fundOverview: fundOverviews[fundId],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
