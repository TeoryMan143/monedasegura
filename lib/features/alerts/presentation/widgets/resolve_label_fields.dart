import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/confidence_level.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/domain/severity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../../labeling/domain/label_form.dart';
import '../../../labeling/domain/label_validator.dart';
import '../../domain/resolve_alert_input.dart';

typedef ResolveFormChanged = void Function(LabelForm form, LabelField field);

class ResolveTypeField extends ConsumerWidget {
  const ResolveTypeField({
    required this.action,
    required this.suggested,
    required this.selected,
    required this.onChanged,
    this.error,
    this.enabled = true,
    super.key,
  });

  final ResolveAlertAction action;
  final FraudType suggested;

  final FraudType? selected;
  final ValueChanged<FraudType> onChanged;
  final String? error;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (action == ResolveAlertAction.reject) return const SizedBox.shrink();
    final types = ref.watch(fraudTypesProvider).value ?? const [];
    final isConfirm = action == ResolveAlertAction.confirm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel('Tipo de fraude', required: !isConfirm),
        const SizedBox(height: AppSpace.xs),
        if (isConfirm)
          _SuggestedType(
            chip: [
              for (final type in types)
                if (type.code == suggested.dbValue)
                  TaxonomyChip.fromCatalog(type, selected: true),
            ],
          )
        else
          Wrap(
            spacing: AppSpace.xs,
            runSpacing: AppSpace.xs,
            children: [
              for (final type in types)
                if (FraudType.fromDb(type.code) case final fraudType
                    when fraudType != suggested)
                  TaxonomyChip.fromCatalog(
                    type,
                    selected: fraudType == selected,
                    onTap: enabled ? () => onChanged(fraudType) : null,
                  ),
            ],
          ),
        if (error != null) FieldMessage(error!, isError: true),
      ],
    );
  }
}

class _SuggestedType extends StatelessWidget {
  const _SuggestedType({required this.chip});

  final List<Widget> chip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...chip,
        const SizedBox(width: AppSpace.md),
        const AppIcon(
          AppIcons.lock,
          size: AppIconSize.sm,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpace.xs),
        Flexible(
          child: Text(
            'Sugerido por la IA · no editable al confirmar',
            style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class ResolveLabelFields extends StatefulWidget {
  const ResolveLabelFields({
    required this.action,
    required this.form,
    required this.errors,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final ResolveAlertAction action;
  final LabelForm form;
  final Map<LabelField, String> errors;
  final ResolveFormChanged onChanged;
  final bool enabled;

  @override
  State<ResolveLabelFields> createState() => _ResolveLabelFieldsState();
}

class _ResolveLabelFieldsState extends State<ResolveLabelFields> {
  late final _justification = TextEditingController(
    text: widget.form.justification,
  );

  @override
  void didUpdateWidget(ResolveLabelFields oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  bool get _justificationRequired =>
      widget.action != ResolveAlertAction.confirm ||
      (widget.form.confidence?.requiresJustification ?? false);

  String get _justificationHint => switch (widget.action) {
    ResolveAlertAction.confirm => 'Describe por qué confirmas la alerta…',
    ResolveAlertAction.reject => 'Describe por qué rechazas la alerta…',
    ResolveAlertAction.reclassify => 'Describe por qué reclasificas la alerta…',
  };

  @override
  Widget build(BuildContext context) {
    final form = widget.form;
    final errors = widget.errors;
    final enabled = widget.enabled;
    final showSeverity = widget.action != ResolveAlertAction.reject;

    final confidence = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSegmented<ConfidenceLevel>(
          label: 'Confianza',
          required: true,
          value: form.confidence,
          onChanged: enabled
              ? (level) => _change(
                  LabelField.confidence,
                  form.copyWith(confidence: level),
                )
              : null,
          segments: [
            for (final level in ConfidenceLevel.values)
              AppSegment(
                value: level,
                label: level.label,
                description: level.criteria,
              ),
          ],
        ),
        _Error(errors[LabelField.confidence]),
      ],
    );

    final severity = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSegmented<Severity>(
          label: 'Severidad',
          required: true,
          value: form.severity,
          onChanged: enabled
              ? (level) =>
                    _change(LabelField.severity, form.copyWith(severity: level))
              : null,
          segments: [
            for (final level in Severity.values)
              AppSegment(
                value: level,
                label: level.label,
                description: level.description,
              ),
          ],
        ),
        _Error(errors[LabelField.severity]),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSeverity)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: confidence),
              const SizedBox(width: AppSpace.lg),
              Expanded(child: severity),
            ],
          )
        else
          confidence,
        const SizedBox(height: AppSpace.lg),
        AppTextArea(
          label: 'Justificación',
          hint: _justificationHint,
          controller: _justification,
          enabled: enabled,
          required: _justificationRequired,
          maxLength: maxJustificationLength,
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

class _Error extends StatelessWidget {
  const _Error(this.message);

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return text == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: AppSpace.xs),
            child: FieldMessage(text, isError: true),
          );
  }
}
