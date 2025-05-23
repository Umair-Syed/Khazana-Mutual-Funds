import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';
import 'value_label.dart';

class FundBarChart extends StatelessWidget {
  final double investmentAmount;
  final NavHistoryRange selectedTimeFrame;

  const FundBarChart({
    super.key,
    required this.investmentAmount,
    required this.selectedTimeFrame,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final absoluteReturn = _calculateAbsoluteReturn();
    final isGainPositive = absoluteReturn >= 0;

    final savingsReturn = investmentAmount * 0.035;
    final categoryReturn = investmentAmount * 0.12;
    final directPlanReturn = absoluteReturn.abs();

    return SizedBox(
      height: 200,
      child: Stack(
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
                      '$label\nInvested: ${investmentAmount.formatAsIndianCurrency()}\nGain: ${gain.formatAsIndianCurrency()}\nTotal: ${(investmentAmount + gain).formatAsIndianCurrency()}',
                      TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 12,
                      ),
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
                      final labels = [
                        'Saving A/C',
                        'Category Avg.',
                        'Direct Plan',
                      ];
                      final index = value.toInt();
                      if (index >= 0 && index < labels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
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
                _buildStackedBarGroup(
                  x: 0,
                  baseValue: investmentAmount,
                  gainValue: savingsReturn,
                  baseColor: Colors.grey[800]!,
                  gainColor: Colors.green[600]!,
                ),
                _buildStackedBarGroup(
                  x: 1,
                  baseValue: investmentAmount,
                  gainValue: categoryReturn,
                  baseColor: Colors.grey[800]!,
                  gainColor: Colors.green[600]!,
                ),
                _buildStackedBarGroup(
                  x: 2,
                  baseValue: investmentAmount,
                  gainValue: directPlanReturn,
                  baseColor: Colors.grey[800]!,
                  gainColor:
                      isGainPositive ? Colors.green[600]! : Colors.red[600]!,
                ),
              ],
              groupsSpace: 50,
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: ValueLabel(
                    value:
                        (investmentAmount + savingsReturn)
                            .formatAsIndianCurrency(),
                  ),
                ),
                Expanded(
                  child: ValueLabel(
                    value:
                        (investmentAmount + categoryReturn)
                            .formatAsIndianCurrency(),
                  ),
                ),
                Expanded(
                  child: ValueLabel(
                    value:
                        (investmentAmount + directPlanReturn)
                            .formatAsIndianCurrency(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAbsoluteReturn() {
    final investmentMultiplier = _getTimeFrameMultiplier();
    final projectedValue = investmentAmount * investmentMultiplier;
    return projectedValue - investmentAmount;
  }

  double _getTimeFrameMultiplier() {
    switch (selectedTimeFrame) {
      case NavHistoryRange.oneMonth:
        return 1.02;
      case NavHistoryRange.threeMonths:
        return 1.05;
      case NavHistoryRange.sixMonths:
        return 1.10;
      case NavHistoryRange.oneYear:
        return 1.18;
      case NavHistoryRange.threeYear:
        return 1.55;
      case NavHistoryRange.max:
        return 2.00;
    }
  }

  double _getMaxValue() {
    final absoluteReturn = _calculateAbsoluteReturn();
    final savingsReturn = investmentAmount * 0.035;
    final categoryReturn = investmentAmount * 0.12;
    final directPlanReturn = absoluteReturn.abs();

    final maxReturn = [
      investmentAmount + savingsReturn,
      investmentAmount + categoryReturn,
      investmentAmount + directPlanReturn,
    ].reduce((a, b) => a > b ? a : b);

    return maxReturn * 1.2;
  }

  BarChartGroupData _buildStackedBarGroup({
    required int x,
    required double baseValue,
    required double gainValue,
    required Color baseColor,
    required Color gainColor,
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
}
