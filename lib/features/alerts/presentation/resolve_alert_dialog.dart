import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../labeling/domain/label_form.dart';
import '../domain/alert_detail.dart';
import '../domain/resolve_alert_input.dart';
import '../domain/resolve_validator.dart';
import 'controllers/alerts_providers.dart';
import 'controllers/resolve_alert_controller.dart';
import 'widgets/resolve_label_fields.dart';
import 'widgets/resolve_transactions_list.dart';

Future<void> showResolveAlertDialog({
  required BuildContext context,
  required String alertId,
}) => showAppDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => ResolveAlertDialog(alertId: alertId),
);

class ResolveAlertDialog extends ConsumerWidget {
  const ResolveAlertDialog({required this.alertId, super.key});

  final String alertId;

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final provider = resolveAlertControllerProvider(alertId);
    final resolved = await ref.read(provider.notifier).submit();
    if (!resolved || !context.mounted) return;

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
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = resolveAlertControllerProvider(alertId);
    final state = ref.watch(provider);
    final detailValue = ref.watch(alertDetailProvider(alertId));
    final detail = detailValue.value;
    final conflict = state.failure is ConflictFailure;

    void close() => Navigator.of(context).pop();
    void submit() => _submit(context, ref);

    return AppDialog(
      title: detail == null
          ? 'Resolver alerta'
          : 'Resolver alerta ${detail.alert.code}',
      subtitle: _subtitle(state.action),
      size: AppDialogSize.l,
      body: ScreenState<AlertDetail>(
        value: detailValue,
        onRetry: () => ref.invalidate(alertDetailProvider(alertId)),
        builder: (context, detail) => _Body(alertId: alertId, detail: detail),
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

String _actionLabel(ResolveAlertAction action) => switch (action) {
  ResolveAlertAction.confirm => 'Confirmar',
  ResolveAlertAction.reject => 'Rechazar',
  ResolveAlertAction.reclassify => 'Reclasificar',
};

class _Body extends ConsumerWidget {
  const _Body({required this.alertId, required this.detail});

  final String alertId;
  final AlertDetail detail;

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
        if (state.action != ResolveAlertAction.reject) ...[
          const SizedBox(height: AppSpace.lg),
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
        ],
        const SizedBox(height: AppSpace.lg),
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
        const SizedBox(height: AppSpace.lg),
        ResolveLabelFields(
          action: state.action,
          form: state.form,
          errors: errors,
          enabled: enabled,
          onChanged: controller.change,
        ),
      ],
    );
  }
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

FailureMessage resolveFailureText(Failure failure) => switch (failure) {
  ConflictFailure() => (
    title: 'Otro analista ya resolvió esta alerta.',
    message: 'Cierra esta ventana: el detalle ya muestra el resultado.',
  ),
  NetworkFailure() => (
    title: 'No hay conexión.',
    message: 'Tus datos siguen en el formulario. Usa «Reintentar» al conectar.',
  ),
  ValidationFailure(:final key) => (
    title: 'Revisa los datos',
    message: switch (key) {
      'final_type_must_differ' =>
        'El tipo debe ser distinto del que sugirió la IA.',
      'fraud_type_required' => 'Elige un tipo de fraude.',
      'severity_required' => 'Elige una severidad.',
      'justification_required' => 'Escribe una justificación.',
      _ => 'Algún campo no cumple las reglas. Corrígelo e inténtalo de nuevo.',
    },
  ),
  _ => (
    title: 'No pudimos resolver la alerta.',
    message: 'Inténtalo de nuevo. Tus datos siguen en el formulario.',
  ),
};
