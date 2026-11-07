import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/chart_transforms.dart';
import 'package:monedasegura/features/statistics/domain/confusion_matrix.dart';
import 'package:monedasegura/features/statistics/domain/grouped_count.dart';
import 'package:monedasegura/features/statistics/domain/time_series_point.dart';

void main() {
  int sum(List<int> values) => values.fold(0, (a, b) => a + b);

  group('toPercentages', () {
    test('three equal shares give 34, 33 and 33', () {
      expect(toPercentages([1, 1, 1]), [34, 33, 33]);
    });

    test('always adds up to 100', () {
      for (final counts in [
        [1, 2, 3],
        [7, 7, 7, 7, 7, 7],
        [1, 0, 0],
        [333, 333, 334],
        [5, 1, 1, 1, 1],
        [1],
      ]) {
        expect(sum(toPercentages(counts)), 100, reason: '$counts');
      }
    });

    test('keeps the order and the exact shares', () {
      expect(toPercentages([50, 25, 25]), [50, 25, 25]);
      expect(toPercentages([0, 4]), [0, 100]);
    });

    test('gives zeros when there is nothing to count', () {
      expect(toPercentages([0, 0, 0]), [0, 0, 0]);
      expect(toPercentages([]), isEmpty);
    });
  });

  group('sortedDescending', () {
    test('puts the biggest count first', () {
      final sorted = sortedDescending(const [
        GroupedCount(key: 'A', count: 3),
        GroupedCount(key: 'B', count: 9),
        GroupedCount(key: 'C', count: 5),
      ]);

      expect([for (final g in sorted) g.key], ['B', 'C', 'A']);
    });

    test('keeps the original order when counts tie', () {
      final sorted = sortedDescending(const [
        GroupedCount(key: 'WEB', count: 4),
        GroupedCount(key: 'APP', count: 4),
        GroupedCount(key: 'ATM', count: 9),
        GroupedCount(key: 'POS', count: 4),
      ]);

      expect([for (final g in sorted) g.key], ['ATM', 'WEB', 'APP', 'POS']);
    });

    test('does not change the list it receives', () {
      const original = [
        GroupedCount(key: 'A', count: 1),
        GroupedCount(key: 'B', count: 2),
      ];

      sortedDescending(original);

      expect(original.first.key, 'A');
    });
  });

  group('fillWeeklyGaps', () {
    // 2026-03-02 is a Monday.
    TimeSeriesPoint point(DateTime week, int count) =>
        TimeSeriesPoint(periodStart: week, fraudCount: count);

    test('fills the weeks without frauds with 0, oldest first', () {
      final filled = fillWeeklyGaps(
        [point(DateTime(2026, 3, 16), 2), point(DateTime(2026, 3, 2), 5)],
        DateTime(2026, 3, 2),
        DateTime(2026, 3, 22),
      );

      expect(
        [for (final p in filled) p.periodStart],
        [DateTime(2026, 3, 2), DateTime(2026, 3, 9), DateTime(2026, 3, 16)],
      );
      expect([for (final p in filled) p.fraudCount], [5, 0, 2]);
    });

    test('starts on the Monday of the week of from', () {
      final filled = fillWeeklyGaps(
        [],
        DateTime(2026, 3, 5),
        DateTime(2026, 3, 8),
      );

      expect(filled.single.periodStart, DateTime(2026, 3, 2));
      expect(filled.single.fraudCount, 0);
    });

    test('crosses a month and drops the points out of the range', () {
      final filled = fillWeeklyGaps(
        [point(DateTime(2026, 2, 16), 8), point(DateTime(2026, 3, 2), 1)],
        DateTime(2026, 2, 23),
        DateTime(2026, 3, 9),
      );

      expect(
        [for (final p in filled) p.periodStart],
        [DateTime(2026, 2, 23), DateTime(2026, 3, 2), DateTime(2026, 3, 9)],
      );
      expect([for (final p in filled) p.fraudCount], [0, 1, 0]);
    });

    test('adds up points of the same week', () {
      final filled = fillWeeklyGaps(
        [point(DateTime(2026, 3, 2), 2), point(DateTime(2026, 3, 4), 3)],
        DateTime(2026, 3, 2),
        DateTime(2026, 3, 8),
      );

      expect(filled.single.fraudCount, 5);
    });

    test('an empty range gives no points', () {
      expect(
        fillWeeklyGaps([], DateTime(2026, 4, 1), DateTime(2026, 3, 1)),
        isEmpty,
      );
    });
  });

  group('percentChange', () {
    test('is positive when it grew and negative when it fell', () {
      expect(percentChange(54, 50), closeTo(8, 0.0001));
      expect(percentChange(25, 50), -50);
    });

    test('is 0 when nothing changed', () {
      expect(percentChange(10, 10), 0);
    });

    test('is null when the previous value is 0', () {
      expect(percentChange(5, 0), isNull);
      expect(percentChange(0, 0), isNull);
    });
  });

  group('with a confusion matrix', () {
    // Rows: suggested ATO, PHI, SIM. Columns: final ATO, PHI, no fraud.
    const matrix = ConfusionMatrix(
      rows: ['ATO', 'PHI', 'SIM'],
      columns: ['ATO', 'PHI', ConfusionMatrix.noFraudKey],
      cells: [
        [8, 1, 1],
        [0, 3, 1],
        [0, 0, 0],
      ],
    );

    test('precisionByType is the diagonal over the row', () {
      final precisions = precisionByType(matrix);

      expect(precisions.first.typeCode, 'ATO');
      expect(precisions.first.precision, 0.8);
      expect(precisions.first.alerts, 10);
      expect(precisions[1].typeCode, 'PHI');
      expect(precisions[1].precision, 0.75);
    });

    test('precisionByType leaves out the rows without alerts', () {
      expect(
        [for (final p in precisionByType(matrix)) p.typeCode],
        ['ATO', 'PHI'],
      );
    });

    test('a type that was only ever rejected has precision 0', () {
      const rejected = ConfusionMatrix(
        rows: ['CLO'],
        columns: ['CLO', ConfusionMatrix.noFraudKey],
        cells: [
          [0, 4],
        ],
      );

      expect(precisionByType(rejected).single.precision, 0);
    });

    test('cellIntensity is 1 for the biggest cell and 0 for an empty one', () {
      expect(cellIntensity(8, matrix), 1);
      expect(cellIntensity(4, matrix), 0.5);
      expect(cellIntensity(0, matrix), 0);
    });

    test('cellIntensity is 0 everywhere in an empty matrix', () {
      const empty = ConfusionMatrix(
        rows: ['ATO'],
        columns: ['ATO', ConfusionMatrix.noFraudKey],
        cells: [
          [0, 0],
        ],
      );

      expect(cellIntensity(0, empty), 0);
    });
  });
}
