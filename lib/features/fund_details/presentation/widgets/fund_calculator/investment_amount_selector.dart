import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';

class InvestmentAmountSelector extends StatelessWidget {
  final double investmentAmount;
  final double minInvestment;
  final double maxInvestment;
  final ValueChanged<double> onAmountChanged;

  const InvestmentAmountSelector({
    super.key,
    required this.investmentAmount,
    required this.minInvestment,
    required this.maxInvestment,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Slider(
          value: investmentAmount,
          min: minInvestment,
          max: maxInvestment,
          divisions: 999,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
          onChanged: onAmountChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minInvestment.formatAsIndianCurrency(),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              maxInvestment.formatAsIndianCurrency(),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
