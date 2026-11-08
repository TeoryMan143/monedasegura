import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/painting.dart';

import '../../../core/formatting/date_time.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/chart_transforms.dart';
import '../domain/time_series_point.dart';

// Pure helpers that turn domain data into what the charts of HU-13 draw. They have no
// widgets, so they are tested on their own.

/// Most labels the X axis of «Fraudes en el tiempo» shows before they crowd together.
const maxXAxisLabels = 8;

/// The weekly series as chart points: X is the index of the week, Y its fraud count.
///
/// The series should already pass through `fillWeeklyGaps`, so the weeks are contiguous.
List<FlSpot> toSpots(List<TimeSeriesPoint> points) => [
  for (final (index, point) in points.indexed)
    FlSpot(index.toDouble(), point.fraudCount.toDouble()),
];

/// Every how many weeks the X axis writes a label, so there are at most
/// [maxXAxisLabels] of them.
int xAxisLabelStep(int weeks) =>
    weeks <= maxXAxisLabels ? 1 : (weeks / maxXAxisLabels).ceil();

/// Whether the week at [index] of [weeks] gets an X axis label: the first one and
/// then one every [xAxisLabelStep].
bool showXAxisLabel(int index, int weeks) => index % xAxisLabelStep(weeks) == 0;

/// «3 mar»: the label of a week on the X axis.
String weekAxisLabel(DateTime weekStart) => formatShortDate(weekStart);

/// Tooltip of one week: «Semana del 3 mar · 41 fraudes · +8 % vs. semana anterior».
///
/// The last part is left out when there is no previous week or it had no frauds, as the
/// change would be undefined.
String fraudTooltipText({
  required DateTime weekStart,
  required int count,
  int? previousCount,
}) {
  final parts = [
    'Semana del ${formatShortDate(weekStart)}',
    '$count ${count == 1 ? 'fraude' : 'fraudes'}',
  ];
  final change = previousCount == null
      ? null
      : percentChange(count, previousCount);
  if (change != null) {
    final rounded = change.round();
    parts.add('${rounded > 0 ? '+' : ''}$rounded % vs. semana anterior');
  }
  return parts.join(' · ');
}

/// Background of a confusion matrix cell on the azul ramp. [intensity] is `cellIntensity`
/// (0 to 1).
Color matrixCellColor(double intensity) =>
    Color.lerp(AppColors.azul50, AppColors.azul700, intensity.clamp(0, 1))!;

/// Text colour of a matrix cell: white once its background is dark, so the value keeps
/// its contrast along the whole scale.
Color matrixCellTextColor(double intensity) =>
    matrixCellColor(intensity).computeLuminance() < _darkBackground
    ? AppColors.textOnBrand
    : AppColors.textPrimary;

/// Luminance under which a background takes white text.
const _darkBackground = 0.25;

/// Every how much the Y axis draws a grid line and a number, for a series whose highest
/// point is [maxValue]: a round step (1, 2, 5, 10, 20, 50…) that gives about four lines.
double yAxisInterval(int maxValue) {
  final wanted = maxValue / 4;
  var magnitude = 1.0;
  while (true) {
    for (final factor in const [1, 2, 5]) {
      if (factor * magnitude >= wanted) return factor * magnitude;
    }
    magnitude *= 10;
  }
}

/// The top of the Y axis: [maxValue] rounded up to a whole [interval] (at least one).
double yAxisMax(int maxValue, double interval) =>
    (maxValue <= 0 ? 1 : (maxValue / interval).ceil()) * interval;
