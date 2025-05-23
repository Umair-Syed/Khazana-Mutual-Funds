import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'time_frame_button.dart';

class TimeFrameSelector extends StatelessWidget {
  final NavHistoryRange selectedTimeFrame;
  final ValueChanged<NavHistoryRange> onTimeFrameChanged;

  const TimeFrameSelector({
    super.key,
    required this.selectedTimeFrame,
    required this.onTimeFrameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          TimeFrameButton(
            timeFrame: NavHistoryRange.oneMonth,
            label: '1M',
            isSelected: selectedTimeFrame == NavHistoryRange.oneMonth,
            onTap: () => onTimeFrameChanged(NavHistoryRange.oneMonth),
          ),
          TimeFrameButton(
            timeFrame: NavHistoryRange.threeMonths,
            label: '3M',
            isSelected: selectedTimeFrame == NavHistoryRange.threeMonths,
            onTap: () => onTimeFrameChanged(NavHistoryRange.threeMonths),
          ),
          TimeFrameButton(
            timeFrame: NavHistoryRange.sixMonths,
            label: '6M',
            isSelected: selectedTimeFrame == NavHistoryRange.sixMonths,
            onTap: () => onTimeFrameChanged(NavHistoryRange.sixMonths),
          ),
          TimeFrameButton(
            timeFrame: NavHistoryRange.oneYear,
            label: '1Y',
            isSelected: selectedTimeFrame == NavHistoryRange.oneYear,
            onTap: () => onTimeFrameChanged(NavHistoryRange.oneYear),
          ),
          TimeFrameButton(
            timeFrame: NavHistoryRange.threeYear,
            label: '3Y',
            isSelected: selectedTimeFrame == NavHistoryRange.threeYear,
            onTap: () => onTimeFrameChanged(NavHistoryRange.threeYear),
          ),
          TimeFrameButton(
            timeFrame: NavHistoryRange.max,
            label: 'MAX',
            isSelected: selectedTimeFrame == NavHistoryRange.max,
            onTap: () => onTimeFrameChanged(NavHistoryRange.max),
          ),
        ],
      ),
    );
  }
}
