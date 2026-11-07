import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/confusion_matrix.dart';

void main() {
  // Rows: suggested ATO, PHI. Columns: final ATO, PHI, no fraud.
  const matrix = ConfusionMatrix(
    rows: ['ATO', 'PHI'],
    columns: ['ATO', 'PHI', ConfusionMatrix.noFraudKey],
    cells: [
      [8, 1, 3],
      [0, 5, 2],
    ],
  );

  test('count reads a cell by row and column', () {
    expect(matrix.count(0, 0), 8);
    expect(matrix.count(0, 2), 3);
    expect(matrix.count(1, 1), 5);
  });

  test('rowTotal adds a whole row', () {
    expect(matrix.rowTotal(0), 12);
    expect(matrix.rowTotal(1), 7);
  });

  test('maxCount is the biggest cell', () {
    expect(matrix.maxCount, 8);
  });

  test('the diagonal is a hit and the no-fraud column never is', () {
    expect(matrix.isHit(0, 0), isTrue);
    expect(matrix.isHit(1, 1), isTrue);
    expect(matrix.isHit(0, 1), isFalse);
    expect(matrix.isHit(0, 2), isFalse);
  });

  test('a matrix without alerts is empty', () {
    const empty = ConfusionMatrix(
      rows: ['ATO'],
      columns: ['ATO', ConfusionMatrix.noFraudKey],
      cells: [
        [0, 0],
      ],
    );

    expect(empty.isEmpty, isTrue);
    expect(matrix.isEmpty, isFalse);
  });
}
