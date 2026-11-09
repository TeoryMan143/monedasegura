import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../labeling/domain/label_form.dart';
import '../../labeling/presentation/widgets/label_form_fields.dart';
import '../domain/alert_detail.dart';
import '../domain/resolve_alert_input.dart';
import '../domain/resolve_validator.dart';
import 'controllers/alerts_providers.dart';
import 'controllers/resolve_alert_controller.dart';
import 'widgets/resolve_transactions_list.dart';
import 'widgets/resolve_type_field.dart';

Future<void> showResolveAlertDialog({
  required BuildContext context,
  required String alertId,
}) => showAppDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => ResolveAlertDialog(alertId: alertId),
);

class ResolveAlertDialog extends ConsumerStatefulWidget {
  const ResolveAlertDialog({required this.alertId, super.key});

  final String alertId;

  @override
  ConsumerState<ResolveAlertDialog> createState() => _ResolveAlertDialogState();
}

class _ResolveAlertDialogState extends ConsumerState<ResolveAlertDialog> {
  final _anchors = _FocusAnchors();
  bool _focusedFirstControl = false;

  String get alertId => widget.alertId;

  @override
  void initState() {
    super.initState();
    // The focus starts on the first control, not on the × of the header. The form only
    // exists once the alert is loaded.
    ref.listenManual(alertDetailProvider(alertId), (previous, next) {
      if (_focusedFirstControl || !next.hasValue) return;
      _focusedFirstControl = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _anchors.focusInside(_anchors.action);
      });
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _anchors.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = resolveAlertControllerProvider(alertId);
    final resolved = await ref.read(provider.notifier).submit();
    if (!mounted) return;
    if (!resolved) {
      // A failed check sends the focus to the first field with an error. A save that
      // failed keeps it where it was.
      final state = ref.read(provider);
      final detail = ref.read(alertDetailProvider(alertId)).value;
      if (state.failure == null && detail != null) {
        _anchors.focusFirstError(state, detail);
      }
      return;
    }

    final detail = ref.read(alertDetailProvider(alertId)).value;
    final action = ref.read(provider).action;
    showAppToast(
      context,
      title:
          'Alerta ${detail?.alert.code ?? ''} ${action.status.label.toLowerCase()}'
              .replaceAll('  ', ' '),
      type: AppToastType.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = resolveAlertControllerProvider(alertId);
    final state = ref.watch(provider);
    final detailValue = ref.watch(alertDetailProvider(alertId));
    final detail = detailValue.value;
    final conflict = state.failure is ConflictFailure;

    void close() => Navigator.of(context).pop();
    void submit() => _submit();

    return AppDialog(
      title: detail == null
          ? 'Resolver alerta'
          : 'Resolver alerta ${detail.alert.code}',
      subtitle: _subtitle(state.action),
      size: AppDialogSize.l,
      body: ScreenState<AlertDetail>(
        value: detailValue,
        onRetry: () => ref.invalidate(alertDetailProvider(alertId)),
        builder: (context, detail) =>
            _Body(alertId: alertId, detail: detail, anchors: _anchors),
      ),
      footerLeading: Align(
        alignment: Alignment.centerLeft,
        child: SaveStatus(state: state.saveState, onRetry: submit),
      ),
      actions: [
        if (!conflict)
          AppButton(
            label: 'Cancelar',
            variant: AppButtonVariant.secondary,
            onPressed: state.isSaving ? null : close,
          ),
        if (conflict)
          AppButton(label: 'Cerrar', onPressed: close)
        else
          AppButton(
            label: _primaryLabel(state.action),
            variant: state.action == ResolveAlertAction.reject
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            loading: state.isSaving,
            onPressed: detail == null ? null : submit,
          ),
      ],
      onSubmit: conflict ? close : (detail == null ? null : submit),
      // Nor by the × or Esc while it saves.
      onClose: state.isSaving ? () {} : null,
    );
  }
}

String _subtitle(ResolveAlertAction action) => switch (action) {
  ResolveAlertAction.confirm =>
    'Elige cómo resolver la alerta. Confirmar crea una etiqueta Fraude con el '
        'tipo sugerido por la IA.',
  ResolveAlertAction.reject =>
    'Elige cómo resolver la alerta. Rechazar crea una etiqueta No fraude: la IA '
        'se equivocó.',
  ResolveAlertAction.reclassify =>
    'Elige cómo resolver la alerta. Reclasificar crea una etiqueta Fraude con '
        'otro tipo que el sugerido por la IA.',
};

String _primaryLabel(ResolveAlertAction action) => switch (action) {
  ResolveAlertAction.confirm => 'Confirmar fraude',
  ResolveAlertAction.reject => 'Rechazar alerta',
  ResolveAlertAction.reclassify => 'Reclasificar alerta',
};

String _justificationHint(ResolveAlertAction action) => switch (action) {
  ResolveAlertAction.confirm => 'Describe por qué confirmas la alerta…',
  ResolveAlertAction.reject => 'Describe por qué rechazas la alerta…',
  ResolveAlertAction.reclassify => 'Describe por qué reclasificas la alerta…',
};

String _actionLabel(ResolveAlertAction action) => switch (action) {
  ResolveAlertAction.confirm => 'Confirmar',
  ResolveAlertAction.reject => 'Rechazar',
  ResolveAlertAction.reclassify => 'Reclasificar',
};

/// Invisible focus anchors around each part of the form, so the dialog can move the
/// focus to a part without the widgets exposing their own focus nodes.
class _FocusAnchors {
  FocusNode _anchor(String label) =>
      FocusNode(debugLabel: label, canRequestFocus: false, skipTraversal: true);

  late final action = _anchor('action');
  late final type = _anchor('type');
  late final transactions = _anchor('transactions');
  late final fields = {
    for (final field in [
      LabelField.confidence,
      LabelField.severity,
      LabelField.justification,
    ])
      field: _anchor(field.name),
  };

  void dispose() {
    for (final node in [action, type, transactions, ...fields.values]) {
      node.dispose();
    }
  }

  /// Focuses the first control inside [anchor].
  void focusInside(FocusNode anchor) => anchor.traversalDescendants
      .where((node) => node.canRequestFocus && !node.skipTraversal)
      .firstOrNull
      ?.requestFocus();

  /// Focuses the first part with an error, in the order of the dialog.
  void focusFirstError(ResolveAlertState state, AlertDetail detail) {
    final errors = state.errors(detail.alert.suggestedType);
    final first = [
      if (errors.containsKey(LabelField.fraudTypes)) type,
      if (state.transactionsError(detail.transactions.length) != null)
        transactions,
      for (final entry in fields.entries)
        if (errors.containsKey(entry.key)) entry.value,
    ].firstOrNull;
    if (first != null) focusInside(first);
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.alertId,
    required this.detail,
    required this.anchors,
  });

  final String alertId;
  final AlertDetail detail;
  final _FocusAnchors anchors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = resolveAlertControllerProvider(alertId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final suggested = detail.alert.suggestedType;
    final total = detail.transactions.length;
    final errors = state.visibleErrors(suggested);
    final enabled = !state.isSaving && state.failure is! ConflictFailure;

    final selected = [
      for (final transaction in detail.transactions)
        if (!state.excludedTransactionIds.contains(transaction.transactionId))
          transaction,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.failure case final failure?) ...[
          _FailureBanner(failure),
          const SizedBox(height: AppSpace.xl),
        ],
        _Anchored(
          anchors.action,
          AppSegmented<ResolveAlertAction>(
            label: 'Acción',
            required: true,
            value: state.action,
            onChanged: enabled ? controller.setAction : null,
            segments: [
              for (final action in ResolveAlertAction.values)
                AppSegment(value: action, label: _actionLabel(action)),
            ],
          ),
        ),
        if (state.action != ResolveAlertAction.reject) ...[
          const SizedBox(height: AppSpace.lg),
          _Anchored(
            anchors.type,
            ResolveTypeField(
              action: state.action,
              suggested: suggested,
              selected: state.form.fraudTypes.firstOrNull,
              enabled: enabled,
              error: errors[LabelField.fraudTypes],
              onChanged: (type) => controller.change(
                state.form.copyWith(fraudTypes: [type]),
                LabelField.fraudTypes,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpace.lg),
        _Anchored(
          anchors.transactions,
          ResolveTransactionsList(
            transactions: detail.transactions,
            excluded: state.excludedTransactionIds,
            enabled: enabled,
            onToggle: controller.toggleTransaction,
            error: state.transactionsError(total),
            summary: resolutionSummary(
              action: state.action,
              form: state.form,
              suggested: suggested,
              selectedCount: selected.length,
              alreadyLabeledCount: selected.where((t) => t.isLabeled).length,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        // The action fixes the verdict and the types (ResolveTypeField above), so the
        // shared form only asks for confidence, severity and justification.
        LabelFormFields(
          form: resolutionLabel(
            action: state.action,
            form: state.form,
            suggested: suggested,
          ),
          errors: errors,
          enabled: enabled,
          showVerdict: false,
          showFraudTypes: false,
          sideBySide: true,
          confidenceLabel: 'Confianza',
          justificationRequired:
              state.action != ResolveAlertAction.confirm ||
              (state.form.confidence?.requiresJustification ?? false),
          justificationHint: _justificationHint(state.action),
          justificationHelperText: null,
          fieldFocus: anchors.fields,
          // The form also carries the verdict and the types the action fixed: keep only
          // what the analyst filled in.
          onChanged: (form, field) => controller.change(
            state.form.copyWith(
              confidence: form.confidence,
              severity: form.severity,
              justification: form.justification,
            ),
            field,
          ),
        ),
      ],
    );
  }
}

/// Puts [child] under a focus [anchor] (see [_FocusAnchors]).
class _Anchored extends StatelessWidget {
  const _Anchored(this.anchor, this.child);

  final FocusNode anchor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Focus(focusNode: anchor, child: child);
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner(this.failure);

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final text = resolveFailureText(failure);
    return InlineBanner(
      tone: StatusTone.danger,
      title: text.title,
      message: text.message,
    );
  }
}

/// Text for a failed resolve. Only what is specific to resolving an alert lives here (the
/// conflict and the rule that the database rejected); everything else comes from the
/// shared [failureMessage] so the whole app words an error the same way.
FailureMessage resolveFailureText(Failure failure) {
  final shared = failureMessage(failure);
  return switch (failure) {
    ConflictFailure() => (
      title: 'Otro analista ya resolvió esta alerta.',
      message: 'Cierra esta ventana: el detalle ya muestra el resultado.',
    ),
    ValidationFailure(:final key) when _ruleMessages.containsKey(key) => (
      title: shared.title,
      message: _ruleMessages[key]!,
    ),
    _ => (
      title: shared.title,
      message: '${shared.message} Tus datos siguen en el formulario.',
    ),
  };
}

/// Messages for the rules the database enforces on `resolve_alert`.
const _ruleMessages = {
  'final_type_must_differ': 'El tipo debe ser distinto del que sugirió la IA.',
  'fraud_type_required': 'Elige un tipo de fraude.',
  'severity_required': 'Elige una severidad.',
  'justification_required': 'Escribe una justificación.',
};
