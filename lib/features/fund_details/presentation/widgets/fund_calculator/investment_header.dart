import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';
import 'investment_type_toggle.dart';

class InvestmentHeader extends StatelessWidget {
  final double investmentAmount;
  final bool isOneTime;
  final ValueChanged<bool> onInvestmentTypeChanged;

  const InvestmentHeader({
    super.key,
    required this.investmentAmount,
    required this.isOneTime,
    required this.onInvestmentTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
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
              investmentAmount.formatAsIndianCurrency(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 12),
        InvestmentTypeToggle(
          isOneTime: isOneTime,
          onChanged: onInvestmentTypeChanged,
        ),
      ],
    );
  }
}
