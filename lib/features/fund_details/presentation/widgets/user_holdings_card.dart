import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';

class UserHoldingsCard extends StatelessWidget {
  final double investedAmount;
  final double currentValue;
  final double units;
  final double purchaseNav;
  final double currentNav;

  const UserHoldingsCard({
    super.key,
    required this.investedAmount,
    required this.currentValue,
    required this.units,
    required this.purchaseNav,
    required this.currentNav,
  });

  @override
  Widget build(BuildContext context) {
    final totalGain = currentValue - investedAmount;
    final unitGain = currentNav - purchaseNav;
    final isGainPositive = unitGain >= 0;
    final gainColor = isGainPositive ? Colors.green : Colors.red;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withAlpha(140),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InfoColumn(
              label: 'Invested',
              value: investedAmount.formatAsIndianCurrency(),
            ),
            VerticalDivider(
              color: Theme.of(context).dividerColor.withAlpha(140),
              width: 1,
              thickness: 1,
              endIndent: 12,
              indent: 12,
            ),
            InfoColumn(
              label: 'Current Value',
              value: currentValue.formatAsIndianCurrency(),
            ),
            VerticalDivider(
              color: Theme.of(context).dividerColor.withAlpha(140),
              width: 1,
              thickness: 1,
              endIndent: 12,
              indent: 12,
            ),
            InfoColumn(
              label: 'Total Gain',
              value: totalGain.formatAsIndianCurrency(),
              showArrow: true,
              arrowUp: isGainPositive,
              color: gainColor,
              extraText: unitGain.formatWithPrecision(1),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool showArrow;
  final bool arrowUp;
  final Color? color;
  final String? extraText;

  const InfoColumn({
    super.key,
    required this.label,
    required this.value,
    this.showArrow = false,
    this.arrowUp = true,
    this.color,
    this.extraText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              if (showArrow && extraText != null) ...[
                const SizedBox(width: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Icon(
                        arrowUp
                            ? CupertinoIcons.chevron_up
                            : CupertinoIcons.chevron_down,
                        size: 12,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      extraText!,
                      style: TextStyle(fontSize: 12, color: color),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
