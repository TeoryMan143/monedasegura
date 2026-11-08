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

/// Called with the whole new [LabelForm] and the field the analyst changed, so the
/// caller can mark it as touched.
typedef LabelFormChanged = void Function(LabelForm form, LabelField field);

/// The label form shared by N-02 (HU-04), A-03 (HU-05) and A-06 (HU-08): verdict, fraud
/// types, confidence, severity and justification.
///
/// The state stays in the caller's controller: the widget shows [form] and reports
/// every change through [onChanged]. It applies the form rules itself:
/// - Types and severity hide for No fraude, and choosing No fraude clears them.
/// - The justification is marked required with confidence Baja or verdict Incierto.
///
/// [errors] are the messages to show under each field, usually [visibleLabelErrors].
///
/// To fix fields, set them in [form] and lock them:
/// - [lockVerdict] disables the verdict (A-06 «Confirmar» fixes Fraude, «Rechazar» fixes
///   No fraude).
/// - [lockedFraudTypes] stay selected and cannot be removed (A-06 «Confirmar» fixes the
///   suggested type; the analyst can still add others).
///
/// ```dart
/// LabelFormFields(
///   form: state.form, // LabelForm(verdict: Verdict.fraud, fraudTypes: [suggested])
///   errors: state.visibleErrors,
///   enabled: !state.isSaving,
///   lockVerdict: true,
///   lockedFraudTypes: {suggested},
///   onChanged: controller.change,
/// )
/// ```
class LabelFormFields extends StatefulWidget {
  const LabelFormFields({
    required this.form,
    required this.onChanged,
    this.errors = const {},
    this.enabled = true,
    this.lockVerdict = false,
    this.lockedFraudTypes = const {},
    super.key,
  });

  final LabelForm form;
  final LabelFormChanged onChanged;
  final Map<LabelField, String> errors;

  /// False disables every field, for example while saving.
  final bool enabled;
  final bool lockVerdict;
  final Set<FraudType> lockedFraudTypes;

  @override
  State<LabelFormFields> createState() => _LabelFormFieldsState();
}

class _LabelFormFieldsState extends State<LabelFormFields> {
  // Owned here so the text and the cursor survive rebuilds and a failed save (E-03).
  late final _justification = TextEditingController(
    text: widget.form.justification,
  );

  @override
  void didUpdateWidget(LabelFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only a change from outside (a reload, a reset) rewrites the text.
    if (widget.form.justification != _justification.text) {
      _justification.text = widget.form.justification;
    }
  }

  @override
  void dispose() {
    _justification.dispose();
    super.dispose();
  }

  void _change(LabelField field, LabelForm form) =>
      widget.onChanged(form, field);

  void _setVerdict(Verdict verdict) => _change(
    LabelField.verdict,
    verdict == Verdict.notFraud
        ? widget.form.copyWith(
            verdict: verdict,
            fraudTypes: const [],
            severity: null,
          )
        : widget.form.copyWith(verdict: verdict),
  );

  void _toggleFraudType(FraudType type) {
    if (widget.lockedFraudTypes.contains(type)) return;
    final types = [...widget.form.fraudTypes];
    types.contains(type) ? types.remove(type) : types.add(type);
    _change(LabelField.fraudTypes, widget.form.copyWith(fraudTypes: types));
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.form;
    final errors = widget.errors;
    final enabled = widget.enabled;
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
          onChanged: enabled && !widget.lockVerdict ? _setVerdict : null,
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
            locked: widget.lockedFraudTypes,
            onToggle: enabled ? _toggleFraudType : null,
          ),
          _Error(errors[LabelField.fraudTypes]),
        ],
        const SizedBox(height: AppSpace.lg),
        AppSegmented<ConfidenceLevel>(
          label: 'Nivel de confianza',
          required: true,
          value: confidence,
          onChanged: enabled
              ? (level) => _change(
                  LabelField.confidence,
                  form.copyWith(confidence: level),
                )
              : null,
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
            onChanged: enabled
                ? (level) => _change(
                    LabelField.severity,
                    form.copyWith(severity: level),
                  )
                : null,
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
          controller: _justification,
          enabled: enabled,
          maxLength: maxJustificationLength,
          required: _justificationRequired(form),
          helperText: 'Obligatoria con confianza Baja o veredicto Incierto.',
          errorText: errors[LabelField.justification],
          onChanged: (text) => _change(
            LabelField.justification,
            form.copyWith(justification: text),
          ),
        ),
      ],
    );
  }
}

bool _justificationRequired(LabelForm form) =>
    form.verdict == Verdict.uncertain ||
    (form.confidence?.requiresJustification ?? false);

/// One chip per row of `fraud_types`, with its taxonomy colour. A locked type does not
/// respond to taps.
class _FraudTypes extends ConsumerWidget {
  const _FraudTypes({
    required this.selected,
    required this.locked,
    required this.onToggle,
  });

  final List<FraudType> selected;
  final Set<FraudType> locked;
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
          if (FraudType.fromDb(type.code) case final fraudType)
            TaxonomyChip.fromCatalog(
              type,
              selected: selected.contains(fraudType),
              onTap: toggle == null || locked.contains(fraudType)
                  ? null
                  : () => toggle(fraudType),
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
