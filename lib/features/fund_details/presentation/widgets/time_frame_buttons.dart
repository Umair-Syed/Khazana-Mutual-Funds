import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';

class TimeFrameButton extends StatelessWidget {
  final NavHistoryRange timeFrame;
  final String label;
  final NavHistoryRange selectedTimeFrame;
  final Function(NavHistoryRange) onTimeFrameChanged;

  const TimeFrameButton({
    super.key,
    required this.timeFrame,
    required this.label,
    required this.selectedTimeFrame,
    required this.onTimeFrameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedTimeFrame == timeFrame;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: () => onTimeFrameChanged(timeFrame),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isSelected
                        ? Colors.white
                        : Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(180),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
