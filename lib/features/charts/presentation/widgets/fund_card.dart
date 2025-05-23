import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_mutual_funds/core/extensions/color_extensions.dart';
import 'package:khazana_mutual_funds/core/navigation/routes.dart';
import '../../domain/entities/fund_entity.dart';

class FundCard extends StatelessWidget {
  final FundEntity fund;

  const FundCard({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoute.fundDetails.name,
          pathParameters: {'fundId': fund.id},
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: theme.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withAlpha(190),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fund.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Row(
                    children: [
                      Text(
                        'NAV ',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(180),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '₹${fund.nav.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fund.category,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(180),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '1D ',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(180),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${fund.oneYearReturn.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: context.dividerColor, height: 1, thickness: 1),
              const SizedBox(height: 8),
              PerformanceMetricsRow(
                oneYearReturn: fund.oneYearReturn,
                threeYearReturn: fund.threeYearReturn,
                fiveYearReturn: fund.fiveYearReturn,
                expenseRatio: fund.expenseRatio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerformanceMetricsRow extends StatelessWidget {
  final double oneYearReturn;
  final double threeYearReturn;
  final double fiveYearReturn;
  final double expenseRatio;

  const PerformanceMetricsRow({
    super.key,
    required this.oneYearReturn,
    required this.threeYearReturn,
    required this.fiveYearReturn,
    required this.expenseRatio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.colorScheme.onSurface.withAlpha(190);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetric('1Y', oneYearReturn, labelColor, theme),
        _buildMetric('3Y', threeYearReturn, labelColor, theme),
        _buildMetric('5Y', fiveYearReturn, labelColor, theme),
        _buildMetric('Exp. Ratio', expenseRatio, labelColor, theme),
      ],
    );
  }

  Widget _buildMetric(
    String label,
    double value,
    Color labelColor,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(
            color: labelColor,
            // fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.green,
            // fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
