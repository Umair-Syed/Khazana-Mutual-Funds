import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_model.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';

class FundNavChart extends StatefulWidget {
  final List<NavPoint> navHistory;
  final NavHistoryRange selectedTimeFrame;
  final double changeAmount;
  final double changePercentage;
  final Function(NavHistoryRange) onTimeFrameChanged;

  const FundNavChart({
    super.key,
    required this.navHistory,
    required this.selectedTimeFrame,
    required this.changeAmount,
    required this.changePercentage,
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
        // Chart Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: NAV change info
            Row(
              children: [
                Container(
                  width: 18,
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'NAV',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(180),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.changePercentage.abs().toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${widget.changeAmount.toStringAsFixed(2)})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // Right side: NAV button
            ElevatedButton(
              onPressed: () {
                // Nav comparison feature to be implemented later
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withAlpha(180),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'NAV',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

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
                        (value, meta) => _buildXAxisLabel(value, context),
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
              _buildTimeFrameButton(context, NavHistoryRange.oneMonth, '1M'),
              _buildTimeFrameButton(context, NavHistoryRange.threeMonths, '3M'),
              _buildTimeFrameButton(context, NavHistoryRange.sixMonths, '6M'),
              _buildTimeFrameButton(context, NavHistoryRange.oneYear, '1Y'),
              _buildTimeFrameButton(context, NavHistoryRange.threeYear, '3Y'),
              _buildTimeFrameButton(context, NavHistoryRange.max, 'MAX'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFrameButton(
    BuildContext context,
    NavHistoryRange timeFrame,
    String label,
  ) {
    final isSelected = widget.selectedTimeFrame == timeFrame;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: () => widget.onTimeFrameChanged(timeFrame),
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

  Widget _buildXAxisLabel(double value, BuildContext context) {
    if (widget.navHistory.isEmpty) return const SizedBox.shrink();

    // Convert normalized value (0-1) to actual index
    final index = (value * (widget.navHistory.length - 1)).round().clamp(
      0,
      widget.navHistory.length - 1,
    );
    final navPoint = widget.navHistory[index];
    final date = navPoint.date;

    // Format date based on time range
    String dateText;
    switch (widget.selectedTimeFrame) {
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

  double _getXAxisInterval() {
    if (widget.navHistory.isEmpty) return 1.0;

    // Calculate reasonable intervals based on data length
    final length = widget.navHistory.length;
    if (length <= 7) return 1.0 / (length - 1);
    if (length <= 30) return 0.2; // Show 5 labels
    if (length <= 90) return 0.25; // Show 4 labels
    return 0.33; // Show 3 labels for longer periods
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
