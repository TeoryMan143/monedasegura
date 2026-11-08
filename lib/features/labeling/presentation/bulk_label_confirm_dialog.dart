import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/verdict.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../domain/label_form.dart';
import '../domain/transaction_selection.dart';

/// Asks before applying the label of A-03 to [selection]. True when the analyst
/// confirms (HU-05).
Future<bool> confirmBulkLabel({
  required BuildContext context,
  required TransactionSelection selection,
  required LabelForm form,
}) async =>
    await showAppDialog<bool>(
      context: context,
      builder: (context) =>
          BulkLabelConfirmDialog(selection: selection, form: form),
    ) ??
    false;

/// A-03 · confirmation: how many labels change and how many are new (HU-05).
///
/// «Se modificarán» counts the transactions that already had a label, which the new one
/// replaces; «Se crearán» the ones without a label.
class BulkLabelConfirmDialog extends StatelessWidget {
  const BulkLabelConfirmDialog({
    required this.selection,
    required this.form,
    super.key,
  });

  final TransactionSelection selection;
  final LabelForm form;

  @override
  Widget build(BuildContext context) {
    final numbers = NumberFormat.decimalPattern('es');
    String transactions(int count) =>
        count == 1 ? '1 transacción' : '${numbers.format(count)} transacciones';

    final total = selection.count;
    final labeled = selection.labeledCount;
    final created = total - labeled;
    void confirm() => Navigator.of(context).pop(true);

    return AppDialog(
      title: '¿Aplicar la clasificación a ${transactions(total)}?',
      subtitle: labelSummary(form),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Fact(
            label: 'Se modificarán',
            value: labeled == 0
                ? 'Ninguna: ninguna tenía etiqueta'
                : '${transactions(labeled)} que ya '
                      '${labeled == 1 ? 'tenía' : 'tenían'} etiqueta',
          ),
          const SizedBox(height: AppSpace.md),
          _Fact(
            label: 'Se crearán',
            value: created == 1
                ? '1 etiqueta nueva'
                : '${numbers.format(created)} etiquetas nuevas',
          ),
          const SizedBox(height: AppSpace.md),
          const _Fact(
            label: 'Auditoría',
            value: 'Cada cambio queda registrado con tu usuario y la fecha',
          ),
        ],
      ),
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: 'Aplicar a ${transactions(total)}',
          onPressed: confirm,
        ),
      ],
      onSubmit: confirm,
    );
  }
}

/// «Fraude · LAV Lavado / fraccionamiento · Confianza Alta · Severidad Crítica»: the
/// label that will be applied, with the domain labels of each field.
String labelSummary(LabelForm form) {
  final verdict = form.verdict;
  final confidence = form.confidence;
  final severity = form.severity;
  return [
    ?verdict?.label,
    if (verdict != Verdict.notFraud)
      for (final type in form.fraudTypes) '${type.code} ${type.label}',
    if (confidence != null) 'Confianza ${confidence.label}',
    if (verdict != Verdict.notFraud && severity != null)
      'Severidad ${severity.label}',
  ].join(' · ');
}

/// One line of the confirmation: a bold label and its value.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: _factLabelWidth,
        child: Text(label, style: AppText.bodyMSemiBold),
      ),
      const SizedBox(width: AppSpace.lg),
      Expanded(
        child: Text(
          value,
          style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
        ),
      ),
    ],
  );
}

/// Width of the labels of [_Fact], so the values line up as in Figma.
const _factLabelWidth = 120.0;
