import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../domain/transaction_selection.dart';
import 'bulk_label_confirm_dialog.dart';
import 'controllers/bulk_label_controller.dart';
import 'widgets/label_form_fields.dart';

/// Opens A-03 for the checked transactions of the table of [scope] (HU-05).
///
/// [onApplied] runs after the labels are saved, so the caller refreshes its own data
/// (the A-02 table and progress). A-01 is refreshed by the controller.
Future<void> showBulkLabelDialog({
  required BuildContext context,
  required String scope,
  required TransactionSelection selection,
  VoidCallback? onApplied,
}) => showAppDialog<void>(
  context: context,
  // Saving must not be cut by a click outside.
  barrierDismissible: false,
  builder: (context) =>
      BulkLabelDialog(scope: scope, selection: selection, onApplied: onApplied),
);

/// A-03 · Classify several transactions (HU-05): one form for every selected
/// transaction, a confirmation with the counts, then a single save.
///
/// [selection] is the one the analyst opened it with: it does not change while the
/// dialog is open, and the counts of the title and the confirmation come from it.
class BulkLabelDialog extends ConsumerStatefulWidget {
  const BulkLabelDialog({
    required this.scope,
    required this.selection,
    this.onApplied,
    super.key,
  });

  final String scope;
  final TransactionSelection selection;
  final VoidCallback? onApplied;

  @override
  ConsumerState<BulkLabelDialog> createState() => _BulkLabelDialogState();
}

class _BulkLabelDialogState extends ConsumerState<BulkLabelDialog> {
  Future<void> _apply() async {
    final provider = bulkLabelProvider(widget.scope);
    final notifier = ref.read(provider.notifier);
    if (ref.read(provider).isSaving || !notifier.review()) return;

    final confirmed = await confirmBulkLabel(
      context: context,
      selection: widget.selection,
      form: ref.read(provider).form,
    );
    if (!confirmed || !mounted) return;

    final applied = await notifier.apply(widget.selection);
    if (!mounted) return;
    if (!applied) {
      final failure = ref.read(provider).failure;
      if (failure != null) {
        final text = failureMessage(failure);
        showAppToast(
          context,
          title: 'No se aplicó la clasificación',
          message: '${text.message} Tus datos siguen en el formulario.',
          type: AppToastType.error,
        );
      }
      return;
    }
    showAppToast(
      context,
      title:
          'Clasificación aplicada a ${bulkLabelCount(widget.selection.count)}',
      type: AppToastType.success,
    );
    widget.onApplied?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bulkLabelProvider(widget.scope));
    final selection = widget.selection;
    final labeled = selection.labeledCount;
    final unlabeled = selection.count - labeled;
    final numbers = NumberFormat.decimalPattern('es');

    return AppDialog(
      title: bulkLabelTitle(selection.count),
      subtitle: [
        '${numbers.format(unlabeled)} sin etiquetar',
        '${numbers.format(labeled)} ya ${labeled == 1 ? 'etiquetada' : 'etiquetadas'}',
      ].join(' · '),
      size: AppDialogSize.l,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labeled > 0) ...[
            InlineBanner(
              tone: StatusTone.warning,
              title: labeled == 1
                  ? '1 transacción ya tiene etiqueta'
                  : '${numbers.format(labeled)} transacciones ya tienen etiqueta',
              message:
                  'Al aplicar, su etiqueta se reemplaza por esta. El cambio queda '
                  'en el historial de cada transacción.',
            ),
            const SizedBox(height: AppSpace.xl),
          ],
          // One form for every selected transaction, the same one as N-02.
          LabelFormFields(
            form: state.form,
            errors: state.visibleErrors,
            enabled: !state.isSaving,
            onChanged: (form, field) => ref
                .read(bulkLabelProvider(widget.scope).notifier)
                .change(form, field),
          ),
        ],
      ),
      footerLeading: Align(
        alignment: Alignment.centerLeft,
        child: SaveStatus(state: state.saveState, onRetry: _apply),
      ),
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: state.isSaving ? null : () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: 'Aplicar a ${bulkLabelCount(selection.count)}',
          loading: state.isSaving,
          onPressed: _apply,
        ),
      ],
      onSubmit: _apply,
      // Nor by the × or Esc while it saves.
      onClose: state.isSaving ? () {} : null,
    );
  }
}

/// «Clasificar 3 transacciones», the title of A-03 and the action that opens it.
String bulkLabelTitle(int count) => 'Clasificar ${bulkLabelCount(count)}';

/// «1 transacción» / «3 transacciones».
String bulkLabelCount(int count) => count == 1
    ? '1 transacción'
    : '${NumberFormat.decimalPattern('es').format(count)} transacciones';
