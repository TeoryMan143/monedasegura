import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/verdict.dart';
import '../../labeling/domain/label_form.dart';
import '../../labeling/domain/label_validator.dart';
import 'resolve_alert_input.dart';

LabelForm resolutionLabel({
  required ResolveAlertAction action,
  required LabelForm form,
  required FraudType suggested,
}) {
  switch (action) {
    case ResolveAlertAction.confirm:
      return form.copyWith(verdict: Verdict.fraud, fraudTypes: [suggested]);
    case ResolveAlertAction.reject:
      return form.copyWith(
        verdict: Verdict.notFraud,
        fraudTypes: const [],
        severity: null,
      );
    case ResolveAlertAction.reclassify:
      return form.copyWith(verdict: Verdict.fraud);
  }
}

Map<LabelField, String> validateResolution({
  required ResolveAlertAction action,
  required LabelForm form,
  required FraudType suggested,
}) {
  final errors = validateLabel(
    resolutionLabel(action: action, form: form, suggested: suggested),
  );

  if (action == ResolveAlertAction.reclassify) {
    final types = form.fraudTypes;
    if (types.length > 1) {
      errors[LabelField.fraudTypes] = 'Elige un solo tipo de fraude.';
    } else if (types.length == 1 && types.single == suggested) {
      errors[LabelField.fraudTypes] =
          'Elige un tipo distinto de ${suggested.dbValue}.';
    }
  }

  if (form.justification.trim().isEmpty) {
    switch (action) {
      case ResolveAlertAction.reject:
        errors[LabelField.justification] =
            'Explica por qué rechazas la alerta.';
      case ResolveAlertAction.reclassify:
        errors[LabelField.justification] = 'Explica la reclasificación.';
      case ResolveAlertAction.confirm:
        break;
    }
  }

  return errors;
}

String? validateTransactionSelection(int selectedCount) =>
    selectedCount > 0 ? null : 'Deja al menos una transacción marcada.';

String? resolutionSummary({
  required ResolveAlertAction action,
  required LabelForm form,
  required FraudType suggested,
  required int selectedCount,
  required int alreadyLabeledCount,
}) {
  if (selectedCount <= 0) return null;

  final label = resolutionLabel(
    action: action,
    form: form,
    suggested: suggested,
  );
  final type = label.fraudTypes.firstOrNull;
  final result = type == null
      ? label.verdict!.label
      : '${label.verdict!.label} · ${type.label}';

  final labeling = selectedCount == 1
      ? 'Se etiquetará 1 transacción como $result.'
      : 'Se etiquetarán $selectedCount transacciones como $result.';

  if (alreadyLabeledCount <= 0) return labeling;
  final replacing = alreadyLabeledCount == 1
      ? '1 ya tenía etiqueta y se reemplazará.'
      : '$alreadyLabeledCount ya tenían etiqueta y se reemplazarán.';
  return '$labeling $replacing';
}
