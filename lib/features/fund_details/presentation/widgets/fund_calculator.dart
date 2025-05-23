import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'fund_calculator/index.dart';

class FundCalculator extends StatefulWidget {
  final String fundId;
  final double initialNav;
  final double currentNav;

  const FundCalculator({
    super.key,
    required this.fundId,
    required this.initialNav,
    required this.currentNav,
  });

  @override
  State<FundCalculator> createState() => _FundCalculatorState();
}

class _FundCalculatorState extends State<FundCalculator> {
  double _investmentAmount = 200000;
  final double _minInvestment = 100000;
  final double _maxInvestment = 1000000;
  NavHistoryRange _selectedTimeFrame = NavHistoryRange.oneYear;
  bool _isOneTime = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withAlpha(120), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InvestmentHeader(
            investmentAmount: _investmentAmount,
            isOneTime: _isOneTime,
            onInvestmentTypeChanged: (isOneTime) {
              setState(() => _isOneTime = isOneTime);
            },
          ),
          const SizedBox(height: 16),
          InvestmentAmountSelector(
            investmentAmount: _investmentAmount,
            minInvestment: _minInvestment,
            maxInvestment: _maxInvestment,
            onAmountChanged: (amount) {
              setState(() => _investmentAmount = amount);
            },
          ),
          const SizedBox(height: 24),
          ReturnsDisplay(
            investmentAmount: _investmentAmount,
            selectedTimeFrame: _selectedTimeFrame,
          ),
          const SizedBox(height: 24),
          FundBarChart(
            investmentAmount: _investmentAmount,
            selectedTimeFrame: _selectedTimeFrame,
          ),
          const SizedBox(height: 16),
          TimeFrameSelector(
            selectedTimeFrame: _selectedTimeFrame,
            onTimeFrameChanged: (timeFrame) {
              setState(() => _selectedTimeFrame = timeFrame);
            },
          ),
        ],
      ),
    );
  }
}
