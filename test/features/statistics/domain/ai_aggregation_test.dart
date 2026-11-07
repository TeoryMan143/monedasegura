import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/ai_aggregation.dart';
import 'package:monedasegura/features/statistics/domain/confusion_matrix.dart';

void main() {
  AiOutcomeRow row(String suggested, String status, String? finalType, int n) =>
      (suggested: suggested, status: status, finalType: finalType, alerts: n);

  // Several rows share the same suggested type and status: they differ in score range.
  final rows = [
    row('ATO', 'confirmed', 'ATO', 6),
    row('ATO', 'confirmed', 'ATO', 2),
    row('ATO', 'rejected', 'NONE', 1),
    row('ATO', 'reclassified', 'PHI', 1),
    row('PHI', 'confirmed', 'PHI', 3),
    row('PHI', 'rejected', 'NONE', 1),
    row('SIM', 'pending', null, 9),
  ];

  group('aiPerformanceFrom', () {
    test('adds up the rows of each status and ignores the pending ones', () {
      final performance = aiPerformanceFrom(rows);

      expect(performance.confirmed, 11);
      expect(performance.rejected, 2);
      expect(performance.reclassified, 1);
      expect(performance.resolvedCount, 14);
    });

    test('computes the precision of each suggested type', () {
      final precision = aiPerformanceFrom(rows).precisionByType;

      expect([for (final p in precision) p.typeCode], ['ATO', 'PHI']);
      expect(precision.first.precision, 0.8);
      expect(precision.first.alerts, 10);
      expect(precision.last.precision, 0.75);
    });

    test('is all zeros without rows', () {
      final performance = aiPerformanceFrom([]);

      expect(performance.resolvedCount, 0);
      expect(performance.precisionByType, isEmpty);
    });
  });

  group('confusionMatrixFrom', () {
    final matrix = confusionMatrixFrom(rows);

    test('rows are the suggested types and columns end with no fraud', () {
      expect(matrix.rows, ['ATO', 'PHI']);
      expect(matrix.columns, ['ATO', 'PHI', ConfusionMatrix.noFraudKey]);
    });

    test('adds up the rows that fall in the same cell', () {
      expect(matrix.cells, [
        [8, 1, 1],
        [0, 3, 1],
      ]);
    });

    test('leaves out the pending alerts', () {
      expect(matrix.rows, isNot(contains('SIM')));
    });

    test('is empty without resolved alerts', () {
      final empty = confusionMatrixFrom([row('ATO', 'pending', null, 4)]);

      expect(empty.rows, isEmpty);
      expect(empty.isEmpty, isTrue);
    });

    test('a final type that was never suggested still has its column', () {
      final reclassified = confusionMatrixFrom([
        row('ATO', 'reclassified', 'SIM', 2),
      ]);

      expect(reclassified.rows, ['ATO']);
      expect(reclassified.columns, ['ATO', 'SIM', ConfusionMatrix.noFraudKey]);
      expect(reclassified.cells, [
        [0, 2, 0],
      ]);
    });
  });
}
