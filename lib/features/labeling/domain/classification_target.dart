import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/account_type.dart';
import '../../../core/domain/channel.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/severity.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';
import 'label_form.dart';

part 'classification_target.freezed.dart';

/// The transaction the N-02 panel classifies (HU-04): what its header shows, its AI
/// alert and its current label.
@freezed
abstract class ClassificationTarget with _$ClassificationTarget {
  const factory ClassificationTarget({
    required int id,

    /// The readable code, e.g. `TX-48219`.
    required String code,
    required DateTime occurredAt,
    required TransactionType type,
    required Channel channel,
    required double amount,
    required Currency currency,
    String? merchantName,
    String? accountLast4,
    AccountType? accountType,

    /// The strongest AI alert on the transaction, if any.
    TargetAlert? alert,

    /// The current label, from the database or saved in this session.
    SavedLabel? label,
  }) = _ClassificationTarget;
}

/// The AI alert shown in the panel's `info` box.
@freezed
abstract class TargetAlert with _$TargetAlert {
  const factory TargetAlert({
    required String code,
    required int score,
    required String summary,
    required FraudType suggestedType,
  }) = _TargetAlert;
}

/// A label that already exists: «Etiquetada por (analista) · (fecha)».
@freezed
abstract class SavedLabel with _$SavedLabel {
  const factory SavedLabel({
    required Verdict verdict,
    required ConfidenceLevel confidence,
    Severity? severity,
    String? justification,
    @Default(<FraudType>[]) List<FraudType> fraudTypes,
    required String analystName,
    required DateTime updatedAt,
  }) = _SavedLabel;

  const SavedLabel._();

  /// The form filled in with this label, to edit it.
  LabelForm toForm() => LabelForm(
    verdict: verdict,
    fraudTypes: fraudTypes,
    confidence: confidence,
    severity: severity,
    justification: justification ?? '',
  );
}
