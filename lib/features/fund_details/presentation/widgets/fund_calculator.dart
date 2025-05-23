import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';

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
  double _investmentAmount = 200000; // Default investment amount
  final double _minInvestment = 100000;
  final double _maxInvestment = 1000000;
  NavHistoryRange _selectedTimeFrame = NavHistoryRange.oneYear;
  bool _isOneTime = true; // true for 1-Time, false for Monthly SIP

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
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withAlpha(120), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and amount in same row
          Row(
            children: [
              Text('If you invested', style: theme.textTheme.titleMedium),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.onSurface.withAlpha(180),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    _investmentAmount.formatAsIndianCurrency(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 1-Time vs SIP toggle - made smaller
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor.withAlpha(140)),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isOneTime = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _isOneTime
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '1-Time',
                          style: TextStyle(
                            color:
                                _isOneTime
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withAlpha(
                                      180,
                                    ),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _isOneTime = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              !_isOneTime
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Monthly SIP',
                          style: TextStyle(
                            color:
                                !_isOneTime
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withAlpha(
                                      180,
                                    ),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
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
            divisions: 999,
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _investmentAmount = value;
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _minInvestment.formatAsIndianCurrency(),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                _maxInvestment.formatAsIndianCurrency(),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Fund returns label and value in same row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This Fund's past returns",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profit % (Absolute Return)',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    absoluteReturn.formatAsIndianCurrency(),
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
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bar chart
          SizedBox(height: 200, child: _buildBarChart(context)),

          const SizedBox(height: 16),

          // Time frame selection
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor.withAlpha(140),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeFrameButton(context, NavHistoryRange.oneMonth, '1M'),
                _buildTimeFrameButton(
                  context,
                  NavHistoryRange.threeMonths,
                  '3M',
                ),
                _buildTimeFrameButton(context, NavHistoryRange.sixMonths, '6M'),
                _buildTimeFrameButton(context, NavHistoryRange.oneYear, '1Y'),
                _buildTimeFrameButton(context, NavHistoryRange.threeYear, '3Y'),
                _buildTimeFrameButton(context, NavHistoryRange.max, 'MAX'),
              ],
            ),
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
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
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
    final theme = Theme.of(context);
    final absoluteReturn = _calculateAbsoluteReturn();
    final isGainPositive = absoluteReturn >= 0;

    // Sample data for comparison
    final savingsReturn = _investmentAmount * 0.035; // 3.5% savings
    final categoryReturn = _investmentAmount * 0.12; // 12% category average
    final directPlanReturn = absoluteReturn.abs();

    return Stack(
      children: [
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxValue(),
            gridData: FlGridData(show: false),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Colors.transparent,
                tooltipPadding: EdgeInsets.zero,
                tooltipMargin: 8,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String label;
                  double gain;
                  switch (groupIndex) {
                    case 0:
                      label = 'Saving A/C';
                      gain = savingsReturn;
                      break;
                    case 1:
                      label = 'Category Avg.';
                      gain = categoryReturn;
                      break;
                    case 2:
                      label = 'Direct Plan';
                      gain = directPlanReturn;
                      break;
                    default:
                      label = '';
                      gain = 0;
                  }

                  return BarTooltipItem(
                    '$label\nInvested: ${_investmentAmount.formatAsIndianCurrency()}\nGain: ${gain.formatAsIndianCurrency()}\nTotal: ${(_investmentAmount + gain).formatAsIndianCurrency()}',
                    TextStyle(color: theme.colorScheme.onSurface, fontSize: 12),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Saving A/C',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      case 1:
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Category Avg.',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      case 2:
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Direct Plan',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
                left: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
                top: const BorderSide(color: Colors.transparent),
              ),
            ),
            barGroups: [
              // Savings Account
              _buildStackedBarGroup(
                x: 0,
                baseValue: _investmentAmount,
                gainValue: savingsReturn,
                baseColor: Colors.grey[800]!,
                gainColor: Colors.green[600]!,
                label: 'Saving A/C',
              ),
              // Category Average
              _buildStackedBarGroup(
                x: 1,
                baseValue: _investmentAmount,
                gainValue: categoryReturn,
                baseColor: Colors.grey[800]!,
                gainColor: Colors.green[600]!,
                label: 'Category Avg.',
              ),
              // Direct Plan
              _buildStackedBarGroup(
                x: 2,
                baseValue: _investmentAmount,
                gainValue: directPlanReturn,
                baseColor: Colors.grey[800]!,
                gainColor:
                    isGainPositive ? Colors.green[600]! : Colors.red[600]!,
                label: 'Direct Plan',
              ),
            ],
            groupsSpace: 50,
          ),
        ),
        // Value labels above bars
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: _buildValueLabel(
                  (_investmentAmount + savingsReturn).formatAsIndianCurrency(),
                  theme,
                ),
              ),
              Expanded(
                child: _buildValueLabel(
                  (_investmentAmount + categoryReturn).formatAsIndianCurrency(),
                  theme,
                ),
              ),
              Expanded(
                child: _buildValueLabel(
                  (_investmentAmount + directPlanReturn)
                      .formatAsIndianCurrency(),
                  theme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValueLabel(String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  BarChartGroupData _buildStackedBarGroup({
    required int x,
    required double baseValue,
    required double gainValue,
    required Color baseColor,
    required Color gainColor,
    required String label,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: baseValue + gainValue,
          color: gainColor,
          width: 50,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
          rodStackItems: [
            BarChartRodStackItem(0, baseValue, baseColor),
            BarChartRodStackItem(baseValue, baseValue + gainValue, gainColor),
          ],
        ),
      ],
    );
  }

  double _getMaxValue() {
    final absoluteReturn = _calculateAbsoluteReturn();
    final savingsReturn = _investmentAmount * 0.035;
    final categoryReturn = _investmentAmount * 0.12;
    final directPlanReturn = absoluteReturn.abs();

    final maxReturn = [
      _investmentAmount + savingsReturn,
      _investmentAmount + categoryReturn,
      _investmentAmount + directPlanReturn,
    ].reduce((a, b) => a > b ? a : b);

    return maxReturn * 1.2; // Add 20% padding
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
