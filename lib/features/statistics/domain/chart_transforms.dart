import 'confusion_matrix.dart';
import 'grouped_count.dart';
import 'time_series_point.dart';
import 'type_precision.dart';

List<int> toPercentages(List<int> counts) {
  final total = counts.fold<int>(0, (sum, count) => sum + count);
  if (total == 0) return List.filled(counts.length, 0);

  final percentages = [for (final count in counts) count * 100 ~/ total];
  final remainders = [for (final count in counts) count * 100 % total];
  var missing = 100 - percentages.fold<int>(0, (sum, value) => sum + value);

  final order = List<int>.generate(counts.length, (index) => index)
    ..sort((a, b) {
      final byRemainder = remainders[b].compareTo(remainders[a]);
      return byRemainder != 0 ? byRemainder : a.compareTo(b);
    });
  for (final index in order) {
    if (missing == 0) break;
    percentages[index]++;
    missing--;
  }
  return percentages;
}

List<GroupedCount> sortedDescending(List<GroupedCount> groups) {
  final indexed = [for (var i = 0; i < groups.length; i++) (i, groups[i])];
  indexed.sort((a, b) {
    final byCount = b.$2.count.compareTo(a.$2.count);
    return byCount != 0 ? byCount : a.$1.compareTo(b.$1);
  });
  return [for (final (_, group) in indexed) group];
}

List<TimeSeriesPoint> fillWeeklyGaps(
  List<TimeSeriesPoint> points,
  DateTime from,
  DateTime to,
) {
  final countByWeek = <DateTime, int>{};
  for (final point in points) {
    final week = _mondayOf(point.periodStart);
    countByWeek[week] = (countByWeek[week] ?? 0) + point.fraudCount;
  }

  final last = _mondayOf(to);
  final filled = <TimeSeriesPoint>[];

  for (
    var week = _mondayOf(from);
    !week.isAfter(last);
    week = DateTime(week.year, week.month, week.day + 7)
  ) {
    filled.add(
      TimeSeriesPoint(periodStart: week, fraudCount: countByWeek[week] ?? 0),
    );
  }
  return filled;
}

double? percentChange(num current, num previous) {
  if (previous == 0) return null;
  return (current - previous) / previous.abs() * 100;
}

List<TypePrecision> precisionByType(ConfusionMatrix matrix) {
  return [
    for (var row = 0; row < matrix.rows.length; row++)
      if (matrix.rowTotal(row) > 0)
        TypePrecision(
          typeCode: matrix.rows[row],
          precision: _hits(matrix, row) / matrix.rowTotal(row),
          alerts: matrix.rowTotal(row),
        ),
  ];
}

double cellIntensity(int count, ConfusionMatrix matrix) {
  final max = matrix.maxCount;
  return max == 0 ? 0 : count / max;
}

int _hits(ConfusionMatrix matrix, int row) {
  final column = matrix.columns.indexOf(matrix.rows[row]);
  return column == -1 ? 0 : matrix.count(row, column);
}

DateTime _mondayOf(DateTime date) =>
    DateTime(date.year, date.month, date.day - (date.weekday - 1));
