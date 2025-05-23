import 'package:flutter/material.dart';

class InvestmentTypeToggle extends StatelessWidget {
  final bool isOneTime;
  final ValueChanged<bool> onChanged;

  const InvestmentTypeToggle({
    super.key,
    required this.isOneTime,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withAlpha(140)),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => onChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color:
                    isOneTime ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '1-Time',
                style: TextStyle(
                  color:
                      isOneTime
                          ? Colors.white
                          : theme.colorScheme.onSurface.withAlpha(180),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => onChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color:
                    !isOneTime ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Monthly SIP',
                style: TextStyle(
                  color:
                      !isOneTime
                          ? Colors.white
                          : theme.colorScheme.onSurface.withAlpha(180),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
