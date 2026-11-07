import 'ai_performance.dart';
import 'chart_transforms.dart';
import 'confusion_matrix.dart';

/// One row of `v_ai_performance`, reduced to what the AI statistics use.
///
/// The view has one row per suggested type, status, final type and score range, so
/// several rows share the same [suggested] and [status].
typedef AiOutcomeRow = ({
  /// `suggested_type_code`.
  String suggested,

  /// `status`: `pending`, `confirmed`, `rejected` or `reclassified`.
  String status,

  /// `final_type_code`: a type, [ConfusionMatrix.noFraudKey] when rejected, or null while
  /// the alert is pending.
  String? finalType,

  /// `alerts`.
  int alerts,
});

/// Adds up the rows of `v_ai_performance` into the counts of the «IA» tab.
///
/// Pending alerts count for nothing: nobody has judged the AI on them yet.
AiPerformance aiPerformanceFrom(Iterable<AiOutcomeRow> rows) {
  int alertsWith(String status) => rows
      .where((row) => row.status == status)
      .fold(0, (sum, row) => sum + row.alerts);

  return AiPerformance(
    confirmed: alertsWith('confirmed'),
    rejected: alertsWith('rejected'),
    reclassified: alertsWith('reclassified'),
    precisionByType: precisionByType(confusionMatrixFrom(rows)),
  );
}

/// Builds the confusion matrix from the rows of `v_ai_performance`.
///
/// Rows are the suggested types and columns are every type plus
/// [ConfusionMatrix.noFraudKey] last, all in alphabetical order. The types are the same
/// on both axes, so a type that was only ever the final one still has its column and the
/// diagonal lines up. Pending alerts are left out.
ConfusionMatrix confusionMatrixFrom(Iterable<AiOutcomeRow> rows) {
  final resolved = rows.where((row) => row.finalType != null).toList();
  const noFraud = ConfusionMatrix.noFraudKey;

  final rowCodes = {for (final row in resolved) row.suggested}.toList()..sort();
  final typeCodes = {
    for (final row in resolved) ...[
      row.suggested,
      if (row.finalType != noFraud) row.finalType!,
    ],
  }.toList()..sort();
  final columnCodes = [...typeCodes, noFraud];

  final cells = [
    for (final _ in rowCodes) List<int>.filled(columnCodes.length, 0),
  ];
  for (final row in resolved) {
    cells[rowCodes.indexOf(row.suggested)][columnCodes.indexOf(
          row.finalType!,
        )] +=
        row.alerts;
  }
  return ConfusionMatrix(rows: rowCodes, columns: columnCodes, cells: cells);
}
