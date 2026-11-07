import 'package:freezed_annotation/freezed_annotation.dart';

part 'confusion_matrix.freezed.dart';

@freezed
abstract class ConfusionMatrix with _$ConfusionMatrix {
  const factory ConfusionMatrix({
    required List<String> rows,

    required List<String> columns,

    required List<List<int>> cells,
  }) = _ConfusionMatrix;

  const ConfusionMatrix._();

  static const noFraudKey = 'NONE';

  int count(int row, int column) => cells[row][column];

  int rowTotal(int row) => cells[row].fold(0, (sum, count) => sum + count);

  int get maxCount => cells.fold(
    0,
    (max, row) => row.fold(max, (max, count) => count > max ? count : max),
  );

  bool isHit(int row, int column) => rows[row] == columns[column];

  bool get isEmpty => maxCount == 0;
}
