import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/confidence_level.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/domain/severity.dart';
import '../../../../core/domain/verdict.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/label_form.dart';
import '../../domain/label_validator.dart';
import '../controllers/classification_controller.dart';

/// The label fields of the N-02 panel (HU-04), with the errors of `validateLabel`.
///
/// Types and severity hide for No fraude. [justification] is owned by the panel, so
/// the text survives a failed save (E-03).
class ClassificationFields extends ConsumerWidget {
  const ClassificationFields({
    required this.transactionId,
    required this.justification,
    super.key,
  });

  final int transactionId;
  final TextEditingController justification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = classificationProvider(transactionId);
    final state = ref.watch(provider).requireValue;
    final controller = ref.read(provider.notifier);
    final form = state.form;
    final errors = state.visibleErrors;
    final enabled = !state.isSaving;
    final isNotFraud = form.verdict == Verdict.notFraud;
    final confidence = form.confidence;
    final severity = form.severity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSegmented<Verdict>(
          label: 'Veredicto',
          required: true,
          value: form.verdict,
          onChanged: enabled ? controller.setVerdict : null,
          segments: [
            for (final verdict in Verdict.values)
              AppSegment(
                value: verdict,
                label: verdict.label,
                icon: verdict.icon,
              ),
          ],
        ),
        _Error(errors[LabelField.verdict]),
        if (!isNotFraud) ...[
          const SizedBox(height: AppSpace.lg),
          FieldLabel(
            'Tipo(s) de fraude',
            required: form.verdict == Verdict.fraud,
          ),
          const SizedBox(height: AppSpace.xs),
          _FraudTypes(
            selected: form.fraudTypes,
            onToggle: enabled ? controller.toggleFraudType : null,
          ),
          _Error(errors[LabelField.fraudTypes]),
        ],
        const SizedBox(height: AppSpace.lg),
        AppSegmented<ConfidenceLevel>(
          label: 'Nivel de confianza',
          required: true,
          value: confidence,
          onChanged: enabled ? controller.setConfidence : null,
          segments: [
            for (final level in ConfidenceLevel.values)
              AppSegment(value: level, label: level.label),
          ],
        ),
        if (confidence != null) FieldMessage(confidence.criteria),
        _Error(errors[LabelField.confidence]),
        if (!isNotFraud) ...[
          const SizedBox(height: AppSpace.lg),
          AppSegmented<Severity>(
            label: 'Severidad',
            required: form.verdict == Verdict.fraud,
            value: severity,
            onChanged: enabled ? controller.setSeverity : null,
            segments: [
              for (final level in Severity.values)
                AppSegment(value: level, label: level.label),
            ],
          ),
          if (severity != null) FieldMessage(severity.description),
          _Error(errors[LabelField.severity]),
        ],
        const SizedBox(height: AppSpace.lg),
        AppTextArea(
          label: 'Justificación',
          hint: 'Qué indicios viste',
          controller: justification,
          enabled: enabled,
          maxLength: maxJustificationLength,
          required: _justificationRequired(form),
          helperText: 'Obligatoria con confianza Baja o veredicto Incierto.',
          errorText: errors[LabelField.justification],
          onChanged: controller.setJustification,
        ),
      ],
    );
  }
}

bool _justificationRequired(LabelForm form) =>
    form.verdict == Verdict.uncertain ||
    (form.confidence?.requiresJustification ?? false);

/// One chip per row of `fraud_types`, with its taxonomy colour.
class _FraudTypes extends ConsumerWidget {
  const _FraudTypes({required this.selected, required this.onToggle});

  final List<FraudType> selected;
  final ValueChanged<FraudType>? onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(fraudTypesProvider).value ?? const [];
    final toggle = onToggle;
    return Wrap(
      spacing: AppSpace.xs,
      runSpacing: AppSpace.xs,
      children: [
        for (final type in types)
          TaxonomyChip.fromCatalog(
            type,
            selected: selected.contains(FraudType.fromDb(type.code)),
            onTap: toggle == null
                ? null
                : () => toggle(FraudType.fromDb(type.code)),
          ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error(this.message);

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return text == null
        ? const SizedBox.shrink()
        : FieldMessage(text, isError: true);
  }
}
