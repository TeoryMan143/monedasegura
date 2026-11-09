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
/// A-06 shows the label part of its own form: it hides what its action already decides
/// ([showVerdict], [showFraudTypes]), places confidence and severity side by side
/// ([sideBySide]) and sets its own [confidenceLabel], [justificationRequired] and
/// justification texts.
///
/// Next to «Confianza» and «Severidad» a [HelpTip] explains the four levels, with the text
/// of the `ConfidenceLevel` and `Severity` enums.
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
    this.showVerdict = true,
    this.showFraudTypes = true,
    this.sideBySide = false,
    this.dense = false,
    this.confidenceLabel = 'Nivel de confianza',
    this.justificationRequired,
    this.justificationHint = 'Qué indicios viste',
    this.justificationHelperText =
        'Obligatoria con confianza Baja o veredicto Incierto.',
    this.fieldFocus = const {},
    super.key,
  });

  final LabelForm form;
  final LabelFormChanged onChanged;
  final Map<LabelField, String> errors;

  /// False disables every field, for example while saving.
  final bool enabled;
  final bool lockVerdict;
  final Set<FraudType> lockedFraudTypes;

  /// False hides the verdict selector, when the caller already fixed it in [form].
  final bool showVerdict;

  /// False hides the fraud types, when the caller shows them elsewhere.
  final bool showFraudTypes;

  /// Confidence and severity in two columns instead of one under the other.
  final bool sideBySide;

  /// Less space between the fields and a two-line justification that grows as it is
  /// written, so the form fits a short window (N-02 on a small screen).
  final bool dense;
  final String confidenceLabel;

  /// Forces the justification to be required (or optional). Null follows the label rules:
  /// required with confidence Baja or verdict Incierto.
  final bool? justificationRequired;
  final String justificationHint;
  final String? justificationHelperText;

  /// Optional anchors the caller can use to move the focus to a field (for example the
  /// first one with an error). Each node wraps its field and cannot take focus itself:
  /// focus its first focusable descendant.
  final Map<LabelField, FocusNode> fieldFocus;

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

  Widget _anchor(LabelField field, Widget child) {
    final node = widget.fieldFocus[field];
    return node == null ? child : Focus(focusNode: node, child: child);
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
    final gap = widget.dense ? AppSpace.sm : AppSpace.lg;

    final confidenceField = _anchor(
      LabelField.confidence,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSegmented<ConfidenceLevel>(
            label: widget.confidenceLabel,
            labelTrailing: HelpTip(
              label: 'Ayuda: ${widget.confidenceLabel.toLowerCase()}',
              message: [
                for (final level in ConfidenceLevel.values)
                  '${level.label}: ${level.criteria}',
              ].join('\n'),
            ),
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
        ],
      ),
    );

    final severityField = _anchor(
      LabelField.severity,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSegmented<Severity>(
            label: 'Severidad',
            labelTrailing: HelpTip(
              label: 'Ayuda: severidad',
              message: [
                for (final level in Severity.values)
                  '${level.label}: ${level.description}',
              ].join('\n'),
            ),
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
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showVerdict) ...[
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
        ],
        if (!isNotFraud && widget.showFraudTypes) ...[
          if (widget.showVerdict) SizedBox(height: gap),
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
        if (widget.showVerdict || (!isNotFraud && widget.showFraudTypes))
          SizedBox(height: gap),
        if (widget.sideBySide && !isNotFraud)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: confidenceField),
              SizedBox(width: gap),
              Expanded(child: severityField),
            ],
          )
        else ...[
          confidenceField,
          if (!isNotFraud) ...[SizedBox(height: gap), severityField],
        ],
        SizedBox(height: gap),
        _anchor(
          LabelField.justification,
          AppTextArea(
            label: 'Justificación',
            hint: widget.justificationHint,
            controller: _justification,
            enabled: enabled,
            maxLength: maxJustificationLength,
            minLines: widget.dense ? 2 : 3,
            required:
                widget.justificationRequired ?? _justificationRequired(form),
            helperText: widget.justificationHelperText,
            errorText: errors[LabelField.justification],
            onChanged: (text) => _change(
              LabelField.justification,
              form.copyWith(justification: text),
            ),
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
