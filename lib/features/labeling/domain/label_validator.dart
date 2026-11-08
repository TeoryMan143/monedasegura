import '../../../core/domain/verdict.dart';
import 'label_form.dart';

/// Longest justification a label accepts, in characters.
const maxJustificationLength = 500;

/// Checks a label form and returns one Spanish message per field that is wrong. An empty
/// map means the label can be saved.
///
/// The prototype does not write to the database, so this is the only check for now. The
/// rules mirror the `CHECK` constraints of `labels`:
/// - A verdict and a confidence level are required.
/// - `fraud` needs at least one fraud type and a severity.
/// - `not_fraud` takes no fraud types and no severity.
/// - Confidence 1 (Baja) or an `uncertain` verdict need a justification.
/// - The justification is at most [maxJustificationLength] characters.
Map<LabelField, String> validateLabel(LabelForm form) {
  final errors = <LabelField, String>{};
  final verdict = form.verdict;
  final confidence = form.confidence;

  if (verdict == null) {
    errors[LabelField.verdict] = 'Elige un veredicto.';
  }
  if (confidence == null) {
    errors[LabelField.confidence] = 'Elige un nivel de confianza.';
  }

  switch (verdict) {
    case Verdict.fraud:
      if (form.fraudTypes.isEmpty) {
        errors[LabelField.fraudTypes] = 'Elige al menos un tipo de fraude.';
      }
      if (form.severity == null) {
        errors[LabelField.severity] = 'Elige una severidad.';
      }
    case Verdict.notFraud:
      if (form.fraudTypes.isNotEmpty) {
        errors[LabelField.fraudTypes] =
            'Una etiqueta de no fraude no lleva tipos de fraude.';
      }
      if (form.severity != null) {
        errors[LabelField.severity] =
            'Una etiqueta de no fraude no lleva severidad.';
      }
    case Verdict.uncertain:
    case null:
      break;
  }

  final justification = form.justification.trim();
  if (justification.isEmpty) {
    if (verdict == Verdict.uncertain) {
      errors[LabelField.justification] =
          'Explica por qué el veredicto es incierto.';
    } else if (confidence?.requiresJustification ?? false) {
      errors[LabelField.justification] =
          'Explica por qué la confianza es ${confidence!.label.toLowerCase()}.';
    }
  } else if (justification.runes.length > maxJustificationLength) {
    errors[LabelField.justification] =
        'La justificación admite máximo $maxJustificationLength caracteres.';
  }

  return errors;
}

/// The errors of [form] a form shows now: all of them after a save attempt
/// ([submitted]), otherwise only those of the fields the analyst [touched].
Map<LabelField, String> visibleLabelErrors(
  LabelForm form, {
  required Set<LabelField> touched,
  required bool submitted,
}) => {
  for (final MapEntry(:key, :value) in validateLabel(form).entries)
    if (submitted || touched.contains(key)) key: value,
};
