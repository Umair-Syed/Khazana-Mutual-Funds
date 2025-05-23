import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_model.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/widgets/time_frame_buttons.dart';

class FundNavChart extends StatefulWidget {
  final List<NavPoint> navHistory;
  final NavHistoryRange selectedTimeFrame;
  final Function(NavHistoryRange) onTimeFrameChanged;

  const FundNavChart({
    super.key,
    required this.navHistory,
    required this.selectedTimeFrame,
    required this.onTimeFrameChanged,
  });

  @override
  State<FundNavChart> createState() => _FundNavChartState();
}

class _FundNavChartState extends State<FundNavChart> {
  List<FlSpot> touchedSpots = [];

  @override
  Widget build(BuildContext context) {
    if (widget.navHistory.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }

    return Column(
      children: [
        // Chart
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget:
                        (value, meta) => NavXAxisLabel(
                          value: value,
                          navHistory: widget.navHistory,
                          selectedTimeFrame: widget.selectedTimeFrame,
                        ),
                    reservedSize: 40,
                    interval: _getXAxisInterval(),
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withAlpha(140),
                  ),
                  left: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _createSpots(),
                  isCurved: true,
                  color: Colors.white,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.onSurface.withAlpha(38),
                        Theme.of(context).colorScheme.onSurface.withAlpha(16),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: const FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBorder: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                  tooltipBorderRadius: BorderRadius.circular(8),
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  tooltipMargin: 32,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((barSpot) {
                      return _buildTooltipItem(barSpot, context);
                    }).toList();
                  },
                  getTooltipColor:
                      (touchedSpot) => Theme.of(context).colorScheme.surface,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                ),
                touchCallback: (
                  FlTouchEvent event,
                  LineTouchResponse? touchResponse,
                ) {
                  if (touchResponse != null &&
                      touchResponse.lineBarSpots != null) {
                    setState(() {
                      touchedSpots =
                          touchResponse.lineBarSpots!
                              .map((spot) => FlSpot(spot.x, spot.y))
                              .toList();
                    });
                  } else {
                    setState(() {
                      touchedSpots = [];
                    });
                  }
                },
                getTouchedSpotIndicator: (
                  LineChartBarData barData,
                  List<int> spotIndexes,
                ) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(180),
                        strokeWidth: 1,
                        // dashArray: [4, 2],
                      ),
                      FlDotData(
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 5,
                                  color: Theme.of(context).colorScheme.primary,
                                  strokeWidth: 3,
                                  strokeColor:
                                      Theme.of(context).colorScheme.surface,
                                ),
                      ),
                    );
                  }).toList();
                },
                getTouchLineStart: (barData, spotIndex) => 0,
                getTouchLineEnd: (barData, spotIndex) => double.infinity,
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines:
                    touchedSpots.map((spot) {
                      return HorizontalLine(
                        y: spot.y,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(180),
                        strokeWidth: 1,
                      );
                    }).toList(),
                verticalLines: [],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Time frame selection buttons
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
              TimeFrameButton(
                timeFrame: NavHistoryRange.oneMonth,
                label: '1M',
                selectedTimeFrame: widget.selectedTimeFrame,
                onTimeFrameChanged: widget.onTimeFrameChanged,
              ),
              TimeFrameButton(
                timeFrame: NavHistoryRange.threeMonths,
                label: '3M',
                selectedTimeFrame: widget.selectedTimeFrame,
                onTimeFrameChanged: widget.onTimeFrameChanged,
              ),
              TimeFrameButton(
                timeFrame: NavHistoryRange.sixMonths,
                label: '6M',
                selectedTimeFrame: widget.selectedTimeFrame,
                onTimeFrameChanged: widget.onTimeFrameChanged,
              ),
              TimeFrameButton(
                timeFrame: NavHistoryRange.oneYear,
                label: '1Y',
                selectedTimeFrame: widget.selectedTimeFrame,
                onTimeFrameChanged: widget.onTimeFrameChanged,
              ),
              TimeFrameButton(
                timeFrame: NavHistoryRange.threeYear,
                label: '3Y',
                selectedTimeFrame: widget.selectedTimeFrame,
                onTimeFrameChanged: widget.onTimeFrameChanged,
              ),
              TimeFrameButton(
                timeFrame: NavHistoryRange.max,
                label: 'MAX',
                selectedTimeFrame: widget.selectedTimeFrame,
                onTimeFrameChanged: widget.onTimeFrameChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<FlSpot> _createSpots() {
    if (widget.navHistory.isEmpty) return [];

    // Find min and max NAV values to scale the chart
    double minNav = widget.navHistory.first.nav;
    double maxNav = widget.navHistory.first.nav;

    for (var navPoint in widget.navHistory) {
      if (navPoint.nav < minNav) minNav = navPoint.nav;
      if (navPoint.nav > maxNav) maxNav = navPoint.nav;
    }

    // Add padding to min and max for better visualization
    final padding = (maxNav - minNav) * 0.1;
    final adjustedMinNav = minNav - padding;
    final adjustedMaxNav = maxNav + padding;
    final navRange = adjustedMaxNav - adjustedMinNav;

    // Create spots normalized between 0 and 1 on the y-axis
    return List.generate(widget.navHistory.length, (index) {
      final navPoint = widget.navHistory[index];
      final normalizedY =
          navRange > 0
              ? (navPoint.nav - adjustedMinNav) / navRange
              : 0.5; // If there's no range, center the point

      // x-axis is the index position divided by total points (0 to 1)
      final normalizedX =
          widget.navHistory.length > 1
              ? index / (widget.navHistory.length - 1)
              : 0.5; // If there's only one point, center it

      return FlSpot(normalizedX, normalizedY);
    });
  }

  LineTooltipItem _buildTooltipItem(
    LineBarSpot touchedSpot,
    BuildContext context,
  ) {
    if (widget.navHistory.isEmpty) {
      return LineTooltipItem('', const TextStyle());
    }

    // Get the index from the touched spot
    final index = touchedSpot.spotIndex.clamp(0, widget.navHistory.length - 1);
    final navPoint = widget.navHistory[index];

    return LineTooltipItem(
      '${navPoint.date.day.toString().padLeft(2, '0')}-${navPoint.date.month.toString().padLeft(2, '0')}-${navPoint.date.year}\n—  NAV: ${navPoint.nav.formatAsIndianCurrency()}',
      TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        shadows: [
          Shadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(180),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  double _getXAxisInterval() {
    if (widget.navHistory.isEmpty) return 1.0;

    // Calculate reasonable intervals based on data length
    final length = widget.navHistory.length;
    if (length <= 7) return 1.0 / (length - 1);
    if (length <= 30) return 0.2; // Show 5 labels
    if (length <= 90) return 0.25; // Show 4 labels
    return 0.33; // Show 3 labels for longer periods
  }
}

class NavXAxisLabel extends StatelessWidget {
  final double value;
  final List<NavPoint> navHistory;
  final NavHistoryRange selectedTimeFrame;

  const NavXAxisLabel({
    super.key,
    required this.value,
    required this.navHistory,
    required this.selectedTimeFrame,
  });

  @override
  Widget build(BuildContext context) {
    if (navHistory.isEmpty) return const SizedBox.shrink();

    // Convert normalized value (0-1) to actual index
    final index = (value * (navHistory.length - 1)).round().clamp(
      0,
      navHistory.length - 1,
    );
    final navPoint = navHistory[index];
    final date = navPoint.date;

    // Format date based on time range
    String dateText;
    switch (selectedTimeFrame) {
      case NavHistoryRange.oneMonth:
      case NavHistoryRange.threeMonths:
        // Show day/month for shorter periods
        dateText = '${date.day}/${date.month}';
        break;
      case NavHistoryRange.sixMonths:
      case NavHistoryRange.oneYear:
        // Show month/year for medium periods
        dateText =
            '${_getMonthName(date.month)} ${date.year.toString().substring(2)}';
        break;
      case NavHistoryRange.threeYear:
      case NavHistoryRange.max:
        // Show year for longer periods
        dateText = date.year.toString();
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        dateText,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
