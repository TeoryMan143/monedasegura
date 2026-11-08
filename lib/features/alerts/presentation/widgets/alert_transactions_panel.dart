import 'package:flutter/widgets.dart';

import '../../../../core/domain/currency.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/alert_transaction.dart';

/// Opens a transaction of the alert in the customer view, with that transaction selected.
typedef OpenAlertTransaction = void Function(int transactionId);

/// «Transacciones involucradas» of A-05 (HU-07): the transactions the AI looked at, the
/// primary one first, in a compact table.
///
/// A click on a row calls [onOpen]. The screen passes it, so this widget does not depend
/// on the app's routes.
class AlertTransactionsPanel extends StatelessWidget {
  const AlertTransactionsPanel({
    required this.transactions,
    required this.onOpen,
    super.key,
  });

  final List<AlertTransaction> transactions;
  final OpenAlertTransaction onOpen;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: 'Transacciones involucradas',
      subtitle: transactions.isEmpty ? null : _summary(),
      padding: EdgeInsets.zero,
      child: AppDataTable<AlertTransaction>(
        shrinkWrap: true,
        columns: _columns,
        rows: transactions,
        rowKey: (transaction) => transaction.transactionId,
        onRowTap: (transaction) => onOpen(transaction.transactionId),
        empty: const EmptyState(
          title: 'Sin transacciones',
          message: 'La alerta no tiene transacciones asociadas.',
        ),
        rowSemanticLabel: (transaction) => 'Abrir ${transaction.code}',
      ),
    );
  }

  /// «2 transacciones · $ 125.500,00 MXN». The total only shows when all of them share
  /// one currency: adding amounts of different currencies means nothing.
  String _summary() {
    final count = transactions.length;
    final noun = count == 1 ? '1 transacción' : '$count transacciones';
    final codes = {for (final t in transactions) t.currencyCode};
    if (codes.length != 1) return noun;
    final total = transactions.fold<double>(0, (sum, t) => sum + t.amount);
    return '$noun · ${formatMoney(total, Currency.fromDb(codes.single))}';
  }
}

final List<AppTableColumn<AlertTransaction>> _columns = [
  AppTableColumn(
    id: 'code',
    label: 'Transacción',
    flex: 2,
    cellBuilder: (context, transaction) => AppTableCell(
      value: transaction.code,
      meta: transaction.isPrimary ? 'Principal' : 'Relacionada',
      valueColor: AppColors.textLink,
    ),
  ),
  AppTableColumn(
    id: 'amount',
    label: 'Monto',
    numeric: true,
    cellBuilder: (context, transaction) => AppTableCell(
      numeric: true,
      value: formatMoney(
        transaction.amount,
        Currency.fromDb(transaction.currencyCode),
        withCode: false,
      ),
      meta: transaction.currencyCode,
    ),
  ),
];
