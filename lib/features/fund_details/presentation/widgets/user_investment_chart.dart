import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_model.dart';
import 'package:khazana_mutual_funds/core/extensions/double_extensions.dart';

class UserInvestmentChart extends StatefulWidget {
  final String currentFundId;
  final List<NavPoint> currentFundNavHistory;
  final NavHistoryRange selectedTimeFrame;
  final Function(NavHistoryRange) onTimeFrameChanged;

  const UserInvestmentChart({
    super.key,
    required this.currentFundId,
    required this.currentFundNavHistory,
    required this.selectedTimeFrame,
    required this.onTimeFrameChanged,
  });

  @override
  State<UserInvestmentChart> createState() => _UserInvestmentChartState();
}

class _UserInvestmentChartState extends State<UserInvestmentChart> {
  static const String niftyMidcapFundId = 'nifty-midcap-150';
  List<NavPoint> niftyNavHistory = [];
  List<FlSpot> touchedSpots = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadNiftyNavHistory();
  }

  @override
  void didUpdateWidget(UserInvestmentChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTimeFrame != widget.selectedTimeFrame) {
      _loadNiftyNavHistory();
    }
  }

  Future<void> _loadNiftyNavHistory() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final niftyData = await FundDataHelper.getNavHistory(
        niftyMidcapFundId,
        widget.selectedTimeFrame,
      );

      if (mounted) {
        setState(() {
          niftyNavHistory = niftyData;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load Nifty data: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor.withAlpha(140),
            width: 1,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor.withAlpha(140),
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading chart data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.currentFundNavHistory.isEmpty && niftyNavHistory.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor.withAlpha(140),
            width: 1,
          ),
        ),
        child: const Center(child: Text('No chart data available')),
      );
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
                  left: const BorderSide(color: Colors.transparent),
                  right: const BorderSide(color: Colors.transparent),
                  top: const BorderSide(color: Colors.transparent),
                ),
              ),
              lineBarsData: _buildLineBarsData(context),
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
                        color:
                            barData.color?.withAlpha(180) ??
                            Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(180),
                        strokeWidth: 1,
                      ),
                      FlDotData(
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 5,
                                  color:
                                      barData.color ??
                                      Theme.of(context).colorScheme.primary,
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

  List<LineChartBarData> _buildLineBarsData(BuildContext context) {
    final lineBars = <LineChartBarData>[];

    // Add current fund line chart
    if (widget.currentFundNavHistory.isNotEmpty) {
      lineBars.add(
        LineChartBarData(
          spots: _createSpotsForNavHistory(widget.currentFundNavHistory),
          isCurved: true,
          color: Theme.of(context).colorScheme.primary,
          barWidth: 2,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(38),
                Theme.of(context).colorScheme.primary.withAlpha(16),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: const FlDotData(show: false),
        ),
      );
    }

    // Add Nifty line chart
    if (niftyNavHistory.isNotEmpty) {
      lineBars.add(
        LineChartBarData(
          spots: _createSpotsForNavHistory(niftyNavHistory),
          isCurved: true,
          color: Colors.orange,
          barWidth: 2,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: false,
          ), // Don't show fill for second line
          dotData: const FlDotData(show: false),
        ),
      );
    }

    return lineBars;
  }

  List<FlSpot> _createSpotsForNavHistory(List<NavPoint> navHistory) {
    if (navHistory.isEmpty) return [];

    // Find min and max NAV values across both datasets for consistent scaling
    double minNav = navHistory.first.nav;
    double maxNav = navHistory.first.nav;

    // Check current fund nav history
    for (var navPoint in widget.currentFundNavHistory) {
      if (navPoint.nav < minNav) minNav = navPoint.nav;
      if (navPoint.nav > maxNav) maxNav = navPoint.nav;
    }

    // Check nifty nav history
    for (var navPoint in niftyNavHistory) {
      if (navPoint.nav < minNav) minNav = navPoint.nav;
      if (navPoint.nav > maxNav) maxNav = navPoint.nav;
    }

    // Add padding to min and max for better visualization
    final padding = (maxNav - minNav) * 0.1;
    final adjustedMinNav = minNav - padding;
    final adjustedMaxNav = maxNav + padding;
    final navRange = adjustedMaxNav - adjustedMinNav;

    // Create spots normalized between 0 and 1 on the y-axis
    return List.generate(navHistory.length, (index) {
      final navPoint = navHistory[index];
      final normalizedY =
          navRange > 0
              ? (navPoint.nav - adjustedMinNav) / navRange
              : 0.5; // If there's no range, center the point

      // x-axis is the index position divided by total points (0 to 1)
      final normalizedX =
          navHistory.length > 1
              ? index / (navHistory.length - 1)
              : 0.5; // If there's only one point, center it

      return FlSpot(normalizedX, normalizedY);
    });
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

  Widget _buildXAxisLabel(double value, BuildContext context) {
    // Use the longer dataset for x-axis labels
    final primaryNavHistory =
        widget.currentFundNavHistory.isNotEmpty
            ? widget.currentFundNavHistory
            : niftyNavHistory;

    if (primaryNavHistory.isEmpty) return const SizedBox.shrink();

    // Convert normalized value (0-1) to actual index
    final index = (value * (primaryNavHistory.length - 1)).round().clamp(
      0,
      primaryNavHistory.length - 1,
    );
    final navPoint = primaryNavHistory[index];
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
    final primaryNavHistory =
        widget.currentFundNavHistory.isNotEmpty
            ? widget.currentFundNavHistory
            : niftyNavHistory;

    if (primaryNavHistory.isEmpty) return 1.0;

    // Calculate reasonable intervals based on data length
    final length = primaryNavHistory.length;
    if (length <= 7) return 1.0 / (length - 1);
    if (length <= 30) return 0.2; // Show 5 labels
    if (length <= 90) return 0.25; // Show 4 labels
    return 0.33; // Show 3 labels for longer periods
  }

  LineTooltipItem _buildTooltipItem(
    LineBarSpot touchedSpot,
    BuildContext context,
  ) {
    final barDataIndex = touchedSpot.barIndex;
    final spotIndex = touchedSpot.spotIndex;

    // Determine which dataset this belongs to
    String fundName;
    List<NavPoint> navHistory;
    Color color;

    if (barDataIndex == 0 && widget.currentFundNavHistory.isNotEmpty) {
      // Current fund (first line)
      fundName = 'Your Investment';
      navHistory = widget.currentFundNavHistory;
      color = Theme.of(context).colorScheme.primary;
    } else if ((barDataIndex == 1 && widget.currentFundNavHistory.isNotEmpty) ||
        (barDataIndex == 0 && widget.currentFundNavHistory.isEmpty)) {
      // Nifty fund (second line or first if current fund is empty)
      fundName = 'Nifty Midcap 150';
      navHistory = niftyNavHistory;
      color = Colors.orange;
    } else {
      return LineTooltipItem('', const TextStyle());
    }

    if (navHistory.isEmpty || spotIndex >= navHistory.length) {
      return LineTooltipItem('', const TextStyle());
    }

    final navPoint = navHistory[spotIndex];

    return LineTooltipItem(
      '${navPoint.date.day.toString().padLeft(2, '0')}-${navPoint.date.month.toString().padLeft(2, '0')}-${navPoint.date.year}\n$fundName\n₹${navPoint.nav.formatAsIndianCurrency()}',
      TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        shadows: [
          Shadow(
            color: color.withAlpha(180),
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
