import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';

class ReturnsDisplay extends StatelessWidget {
  final double investmentAmount;
  final NavHistoryRange selectedTimeFrame;

  const ReturnsDisplay({
    super.key,
    required this.investmentAmount,
    required this.selectedTimeFrame,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final absoluteReturn = _calculateAbsoluteReturn();
    final isGainPositive = absoluteReturn >= 0;
    final returnPercentage = _calculateReturnPercentage();

    return Row(
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
    );
  }

  double _calculateAbsoluteReturn() {
    final investmentMultiplier = _getTimeFrameMultiplier();
    final projectedValue = investmentAmount * investmentMultiplier;
    return projectedValue - investmentAmount;
  }

  double _calculateReturnPercentage() {
    final absoluteReturn = _calculateAbsoluteReturn();
    return (absoluteReturn / investmentAmount) * 100;
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
}
