import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/numbers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/time_series_point.dart';
import '../chart_presentation.dart';

/// Line chart of the frauds per week (A-07): one azul series, soft horizontal grid, dots
/// only under the cursor and a dark tooltip with a vertical crosshair.
///
/// [weeks] must be contiguous (see `fillWeeklyGaps`), so the X axis is the week index.
class FraudLineChart extends StatelessWidget {
  const FraudLineChart({required this.weeks, super.key});

  final List<TimeSeriesPoint> weeks;

  @override
  Widget build(BuildContext context) {
    final highest = weeks.fold(
      0,
      (max, week) => math.max(max, week.fraudCount),
    );
    final interval = yAxisInterval(highest);
    final total = weeks.fold(0, (sum, week) => sum + week.fraudCount);
    final axisStyle = AppText.bodyS.copyWith(color: AppColors.textTertiary);

    return Semantics(
      label:
          'Gráfica de fraudes por semana, de ${formatShortDate(weeks.first.periodStart)} '
          'a ${formatShortDate(weeks.last.periodStart)}: '
          '${formatCount(total)} fraudes en total. El máximo semanal es '
          '${formatCount(highest)}.',
      child: ExcludeSemantics(
        child: SizedBox(
          height: AppSizes.chartHeight,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: math.max(weeks.length - 1, 1).toDouble(),
              minY: 0,
              maxY: yAxisMax(highest, interval),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (_) =>
                    const FlLine(color: AppColors.gris100, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: AppSizes.chartAxisLeft,
                    interval: interval,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(formatCount(value), style: axisStyle),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: AppSizes.chartAxisBottom,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index != value ||
                          index >= weeks.length ||
                          !showXAxisLabel(index, weeks.length)) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          weekAxisLabel(weeks[index].periodStart),
                          style: axisStyle,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: toSpots(weeks),
                  color: AppColors.azul500,
                  barWidth: AppSizes.chartLine,
                  dotData: const FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                getTouchedSpotIndicator: (bar, indexes) => [
                  for (final _ in indexes)
                    TouchedSpotIndicatorData(
                      const FlLine(color: AppColors.gris300, strokeWidth: 1),
                      FlDotData(
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                              radius: AppSpace.xs,
                              color: AppColors.azul500,
                              strokeColor: AppColors.gris0,
                              strokeWidth: AppSpace.xxs,
                            ),
                      ),
                    ),
                ],
                touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: AppSizes.tooltipMaxWidth,
                  fitInsideHorizontally: true,
                  tooltipBorderRadius: BorderRadius.circular(AppRadius.md),
                  getTooltipColor: (_) => AppColors.gris900,
                  getTooltipItems: (spots) => [
                    for (final spot in spots)
                      LineTooltipItem(
                        fraudTooltipText(
                          weekStart: weeks[spot.spotIndex].periodStart,
                          count: weeks[spot.spotIndex].fraudCount,
                          previousCount: spot.spotIndex == 0
                              ? null
                              : weeks[spot.spotIndex - 1].fraudCount,
                        ),
                        AppText.bodyS.copyWith(color: AppColors.textOnBrand),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
