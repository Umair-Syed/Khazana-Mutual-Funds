import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_model.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/widgets/fund_nav_chart.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/widgets/user_investment_chart.dart';

enum ChartType { nav, userInvestment }

class FundChartContainer extends StatefulWidget {
  final String currentFundId;
  final List<NavPoint> navHistory;
  final NavHistoryRange selectedTimeFrame;
  final double changeAmount;
  final double changePercentage;
  final Function(NavHistoryRange) onTimeFrameChanged;

  const FundChartContainer({
    super.key,
    required this.currentFundId,
    required this.navHistory,
    required this.selectedTimeFrame,
    required this.changeAmount,
    required this.changePercentage,
    required this.onTimeFrameChanged,
  });

  @override
  State<FundChartContainer> createState() => _FundChartContainerState();
}

class _FundChartContainerState extends State<FundChartContainer> {
  ChartType selectedChartType = ChartType.nav;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart Header
        _buildChartHeader(context),

        const SizedBox(height: 16),

        // Chart Content
        _buildChartContent(),
      ],
    );
  }

  Widget _buildChartHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: Chart change info or legend for investment chart
        selectedChartType == ChartType.nav
            ? _buildNavChartInfo(context)
            : _buildInvestmentChartLegend(context),
        // Right side: Chart toggle buttons
        Row(children: [_buildChartToggleButton(context)]),
      ],
    );
  }

  Widget _buildNavChartInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'NAV',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${widget.changePercentage.abs().toStringAsFixed(2)}%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          '(${widget.changeAmount.toStringAsFixed(2)})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInvestmentChartLegend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Your Investment',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.changePercentage.abs().toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 18,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Nifty Midcap 150',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
            const SizedBox(width: 8),
            Text(
              '-12.97%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartToggleButton(BuildContext context) {
    final isNavSelected = selectedChartType == ChartType.nav;

    return ElevatedButton(
      onPressed: () {
        if (isNavSelected) {
          setState(() {
            selectedChartType = ChartType.userInvestment;
          });
        } else {
          setState(() {
            selectedChartType = ChartType.nav;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color:
                isNavSelected
                    ? Theme.of(context).colorScheme.primary.withAlpha(180)
                    : Theme.of(context).colorScheme.onSurface.withAlpha(180),
            width: 1,
          ),
        ),
      ),
      child: Text(
        'NAV',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
        ),
      ),
    );
  }

  Widget _buildChartContent() {
    switch (selectedChartType) {
      case ChartType.nav:
        return FundNavChart(
          navHistory: widget.navHistory,
          selectedTimeFrame: widget.selectedTimeFrame,
          onTimeFrameChanged: widget.onTimeFrameChanged,
        );
      case ChartType.userInvestment:
        return UserInvestmentChart(
          currentFundId: widget.currentFundId,
          currentFundNavHistory: widget.navHistory,
          selectedTimeFrame: widget.selectedTimeFrame,
          onTimeFrameChanged: widget.onTimeFrameChanged,
        );
    }
  }
}
