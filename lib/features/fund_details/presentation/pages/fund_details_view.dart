import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/bloc/fund_details_bloc.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/widgets/fund_calculator.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/widgets/fund_chart_container.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/widgets/user_holdings_card.dart';

class FundDetailsView extends StatelessWidget {
  const FundDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FundDetailsBloc, FundDetailsState>(
      builder: (context, state) {
        if (state is FundDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is FundDetailsLoaded) {
          return LoadedView(state: state);
        } else if (state is FundDetailsError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: Text('No fund details available')),
        );
      },
    );
  }
}

class LoadedView extends StatelessWidget {
  final FundDetailsLoaded state;

  const LoadedView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fundDetails = state.fundDetails;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () {
              // Bookmark feature not implemented yet
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fund name and NAV info
              Text(
                fundDetails.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'NAV',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withAlpha(200),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '₹${fundDetails.currentNav.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // vertical line
                  Container(
                    color: theme.colorScheme.outline.withAlpha(150),
                    width: 1,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  ChangeIndicator(
                    label: '1D',
                    change: fundDetails.oneDayChange,
                    percentage: fundDetails.oneDayChangePercentage,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // User Holdings
              UserHoldingsCard(
                investedAmount: fundDetails.userHolding.investedAmount,
                currentValue:
                    fundDetails.userHolding.units * fundDetails.currentNav,
                units: fundDetails.userHolding.units,
                purchaseNav: fundDetails.userHolding.purchaseNav,
                currentNav: fundDetails.currentNav,
              ),

              const SizedBox(height: 24),

              FundChartContainer(
                currentFundId: fundDetails.id,
                navHistory: state.filteredNavHistory,
                selectedTimeFrame: state.selectedTimeFrame,
                changeAmount: state.changeInTimeFrame,
                changePercentage: state.changePercentageInTimeFrame,
                onTimeFrameChanged: (timeFrame) {
                  context.read<FundDetailsBloc>().add(
                    ChangeTimeFrame(timeFrame),
                  );
                },
              ),

              const SizedBox(height: 48),

              // Investment Calculator
              FundCalculator(
                fundId: fundDetails.id,
                initialNav: fundDetails.navHistory.first.nav,
                currentNav: fundDetails.currentNav,
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withAlpha(50),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Sell functionality to be implemented
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sell',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Invest More functionality to be implemented
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Invest More',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_up, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeIndicator extends StatelessWidget {
  final String label;
  final double change;
  final double percentage;

  const ChangeIndicator({
    super.key,
    required this.label,
    required this.change,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon =
        isPositive ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withAlpha(200),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '₹ ${change.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          spacing: 4,
          children: [
            Icon(icon, size: 12, color: color),
            Text(
              '${percentage.abs().toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
