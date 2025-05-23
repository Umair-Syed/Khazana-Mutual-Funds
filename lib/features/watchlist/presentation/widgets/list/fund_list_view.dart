import 'package:flutter/material.dart';
import '../../../../../core/utils/funds_data_utils/fund_model.dart';
import '../watchlist_fund_item.dart';
import '../states/index.dart';

class FundListView extends StatelessWidget {
  final List<String> fundIds;
  final Map<String, FundOverView> fundOverviews;
  final bool isLoadingFundData;
  final Function(String) onRemoveFund;

  const FundListView({
    super.key,
    required this.fundIds,
    required this.fundOverviews,
    required this.isLoadingFundData,
    required this.onRemoveFund,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingFundData) {
      return const LoadingStateWidget(message: 'Loading fund data...');
    }

    return ListView.builder(
      itemCount: fundIds.length,
      itemBuilder: (context, index) {
        final fundId = fundIds[index];

        return Dismissible(
          key: Key(fundId),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          onDismissed: (direction) => onRemoveFund(fundId),
          child: WatchlistFundItem(
            fundId: fundId,
            fundOverview: fundOverviews[fundId],
          ),
        );
      },
    );
  }
}
