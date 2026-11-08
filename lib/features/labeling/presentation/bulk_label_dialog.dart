import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/ui/kit.dart';
import '../domain/transaction_selection.dart';

/// Opens A-03 for the checked transactions of a table (HU-05).
Future<void> showBulkLabelDialog({
  required BuildContext context,
  required TransactionSelection selection,
}) => showAppDialog<void>(
  context: context,
  builder: (context) => BulkLabelDialog(selection: selection),
);

/// A-03 · Classify several transactions (HU-05).
///
/// For now only its frame: the shared label form and the confirmation with the counts
/// come in the next sprint.
class BulkLabelDialog extends StatelessWidget {
  const BulkLabelDialog({required this.selection, super.key});

  final TransactionSelection selection;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: bulkLabelTitle(selection.count),
      size: AppDialogSize.l,
      body: const SizedBox.shrink(),
      bodyPadding: EdgeInsets.zero,
    );
  }
}

/// «Clasificar 3 transacciones», the title of A-03 and the action that opens it.
String bulkLabelTitle(int count) => count == 1
    ? 'Clasificar 1 transacción'
    : 'Clasificar ${NumberFormat.decimalPattern('es').format(count)} '
          'transacciones';
