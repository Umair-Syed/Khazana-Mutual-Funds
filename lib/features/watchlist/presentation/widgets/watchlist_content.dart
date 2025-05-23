import 'package:flutter/material.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart';
import 'empty_states/index.dart';
import 'sort/index.dart';
import 'list/index.dart';

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

  @override
  Widget build(BuildContext context) {
    // No watchlist selected
    if (selectedWatchlist == null) {
      return const NoWatchlistSelected();
    }

    // Watchlist selected but empty
    if (selectedWatchlist!.fundIds.isEmpty) {
      return EmptyWatchlistState(onAddFund: onAddFund);
    }

    // Watchlist has funds
    return _buildWatchlistWithFunds(context);
  }

  Widget _buildWatchlistWithFunds(BuildContext context) {
    final sortedFundIds = _getSortedFundIds();

    return Column(
      children: [
        WatchlistHeader(
          onAddFund: onAddFund,
          onShowSort: () => _showSortBottomSheet(context),
        ),
        Expanded(
          child: FundListView(
            fundIds: sortedFundIds,
            fundOverviews: fundOverviews,
            isLoadingFundData: isLoadingFundData,
            onRemoveFund: onRemoveFund,
          ),
        ),
      ],
    );
  }

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
    if (onSortChanged == null) return;

    SortBottomSheet.show(
      context,
      currentSortOption: currentSortOption,
      onSortChanged: onSortChanged!,
    );
  }
}
