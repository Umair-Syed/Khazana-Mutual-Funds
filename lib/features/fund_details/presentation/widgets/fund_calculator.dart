import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';

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
  double _investmentAmount = 10000; // Default investment amount
  final double _minInvestment = 1000;
  final double _maxInvestment = 100000;
  NavHistoryRange _selectedTimeFrame = NavHistoryRange.oneYear;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = _investmentAmount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate returns
    final absoluteReturn = _calculateAbsoluteReturn();
    final isGainPositive = absoluteReturn >= 0;
    final returnPercentage = _calculateReturnPercentage();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withAlpha(120), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text('If you invested', style: theme.textTheme.titleMedium),

          const SizedBox(height: 16),

          // Investment amount input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixText: '₹ ',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final amount =
                          double.tryParse(value) ?? _investmentAmount;
                      setState(() {
                        _investmentAmount = amount.clamp(
                          _minInvestment,
                          _maxInvestment,
                        );
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              // One-time vs SIP toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '1-Time',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Monthly SIP',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Slider
          Slider(
            value: _investmentAmount,
            min: _minInvestment,
            max: _maxInvestment,
            divisions: 99,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _investmentAmount = value;
                _amountController.text = value.toStringAsFixed(0);
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${_minInvestment.toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                '₹ ${_maxInvestment.toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Fund returns label
          Text("This Fund's past returns", style: theme.textTheme.titleMedium),

          const SizedBox(height: 8),

          Text(
            'Profit % (Absolute Return)',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 8),

          // Returns value
          Text(
            '₹ ${absoluteReturn.abs().toStringAsFixed(0)} L',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isGainPositive ? Colors.green : Colors.red,
            ),
          ),

          Text(
            '${returnPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 14,
              color: isGainPositive ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(height: 24),

          // Bar chart
          SizedBox(height: 100, child: _buildBarChart(context)),

          const SizedBox(height: 16),

          // Time frame selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeFrameButton(context, NavHistoryRange.oneMonth, '1M'),
              _buildTimeFrameButton(context, NavHistoryRange.threeMonths, '3M'),
              _buildTimeFrameButton(context, NavHistoryRange.sixMonths, '6M'),
              _buildTimeFrameButton(context, NavHistoryRange.oneYear, '1Y'),
              _buildTimeFrameButton(context, NavHistoryRange.threeYear, '3Y'),
              _buildTimeFrameButton(context, NavHistoryRange.max, 'MAX'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameButton(
    BuildContext context,
    NavHistoryRange timeFrame,
    String label,
  ) {
    final isSelected = _selectedTimeFrame == timeFrame;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimeFrame = timeFrame;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final absoluteReturn = _calculateAbsoluteReturn();
    final isGainPositive = absoluteReturn >= 0;

    // Simplified stacked bar chart
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Saving Account
        Expanded(
          child: _buildBar(
            context,
            'Saving A/C',
            _investmentAmount * 0.035, // Example 3.5% return on savings
            Colors.grey[400]!,
          ),
        ),
        const SizedBox(width: 16),
        // Category Average
        Expanded(
          child: _buildBar(
            context,
            'Category Avg.',
            _investmentAmount * 0.12, // Example 12% category average
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        // Direct Plan
        Expanded(
          child: _buildBar(
            context,
            'Direct Plan',
            absoluteReturn.abs(),
            isGainPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    final theme = Theme.of(context);
    // Normalize height based on maximum value (simplified)
    final height = (value / _maxInvestment) * 80;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value
        Text(
          '₹${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        // Bar
        Container(
          width: double.infinity,
          height: height.clamp(10, 80),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  double _calculateAbsoluteReturn() {
    // Simplified calculation for example purposes
    final investmentMultiplier = _getTimeFrameMultiplier();
    final projectedValue = _investmentAmount * investmentMultiplier;
    return projectedValue - _investmentAmount;
  }

  double _calculateReturnPercentage() {
    final absoluteReturn = _calculateAbsoluteReturn();
    return (absoluteReturn / _investmentAmount) * 100;
  }

  double _getTimeFrameMultiplier() {
    // These are simplified return rates for demonstration
    switch (_selectedTimeFrame) {
      case NavHistoryRange.oneMonth:
        return 1.02; // 2% in 1 month
      case NavHistoryRange.threeMonths:
        return 1.05; // 5% in 3 months
      case NavHistoryRange.sixMonths:
        return 1.10; // 10% in 6 months
      case NavHistoryRange.oneYear:
        return 1.18; // 18% in 1 year
      case NavHistoryRange.threeYear:
        return 1.55; // 55% in 3 years
      case NavHistoryRange.max:
        return 2.00; // 100% max return
    }
  }
}
