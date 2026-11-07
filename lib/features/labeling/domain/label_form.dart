import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/severity.dart';
import '../../../core/domain/verdict.dart';

part 'label_form.freezed.dart';

/// What the analyst has filled in so far in a label form (HU-04, HU-05 and HU-08).
///
/// Every field can be empty while the form is being filled in. [validateLabel] says what is
/// missing or does not fit.
@freezed
abstract class LabelForm with _$LabelForm {
  const factory LabelForm({
    Verdict? verdict,
    @Default(<FraudType>[]) List<FraudType> fraudTypes,
    ConfidenceLevel? confidence,
    Severity? severity,
    @Default('') String justification,
  }) = _LabelForm;
}

/// The fields of [LabelForm], to place each error under its own control.
enum LabelField { verdict, fraudTypes, confidence, severity, justification }
