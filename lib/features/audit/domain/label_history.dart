import 'package:freezed_annotation/freezed_annotation.dart';

import 'audit_entry.dart';

part 'label_history.freezed.dart';

/// What N-03 shows for one transaction (HU-15): its changes, newest first, and the AI
/// alerts that flagged it, for the note under the list.
@freezed
abstract class LabelHistory with _$LabelHistory {
  const factory LabelHistory({
    required List<AuditEntry> entries,
    @Default(<HistoryAlert>[]) List<HistoryAlert> alerts,
  }) = _LabelHistory;
}

/// An AI alert of the transaction: «Alerta AL-0993 · generada por la IA el 03 mar 22:45
/// (score 76)».
@freezed
abstract class HistoryAlert with _$HistoryAlert {
  const factory HistoryAlert({
    required String code,
    required int score,
    required DateTime generatedAt,
  }) = _HistoryAlert;
}
