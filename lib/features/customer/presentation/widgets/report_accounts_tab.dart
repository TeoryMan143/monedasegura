import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/account_mask.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/customer_report.dart';
import '../../domain/report_enums.dart';
import '../controllers/customer_report_controller.dart';

/// «Cuentas» of the customer report (HU-09): accounts, cards and devices with their
/// status and balance. Figma has no frame for it: it is built with the kit.
class ReportAccountsTab extends ConsumerWidget {
  const ReportAccountsTab({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = customerProductsProvider(customerId);
    return ScreenState(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      builder: (context, products) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Section(
              title: 'Cuentas',
              count: products.accounts.length,
              child: AppDataTable<ReportAccount>(
                shrinkWrap: true,
                rows: products.accounts,
                rowKey: (row) => row.id,
                columns: _accountColumns,
                empty: const EmptyState(title: 'Sin cuentas'),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            _Section(
              title: 'Tarjetas',
              count: products.cards.length,
              child: AppDataTable<ReportCard>(
                shrinkWrap: true,
                rows: products.cards,
                rowKey: (row) => row.id,
                columns: _cardColumns,
                empty: const EmptyState(title: 'Sin tarjetas'),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            _Section(
              title: 'Dispositivos',
              count: products.devices.length,
              child: AppDataTable<ReportDevice>(
                shrinkWrap: true,
                rows: products.devices,
                rowKey: (row) => row.id,
                columns: _deviceColumns,
                empty: const EmptyState(title: 'Sin dispositivos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _accountColumns = <AppTableColumn<ReportAccount>>[
  AppTableColumn(
    id: 'account',
    label: 'Cuenta',
    cellBuilder: (context, row) => AppTableCell(
      value: '${row.type.label} ${maskAccount(row.last4)}',
      meta: row.bankName,
      leadingIcon: row.type.icon,
    ),
  ),
  AppTableColumn(
    id: 'balance',
    label: 'Saldo',
    numeric: true,
    cellBuilder: (context, row) {
      final balance = row.balance;
      final limit = row.creditLimit;
      return AppTableCell(
        numeric: true,
        value: balance == null ? '—' : formatMoney(balance, row.currency),
        meta: limit == null ? null : 'Cupo ${formatMoney(limit, row.currency)}',
      );
    },
  ),
  AppTableColumn(
    id: 'opened',
    label: 'Apertura',
    cellBuilder: (context, row) {
      final openedOn = row.openedOn;
      return AppTableCell(value: openedOn == null ? '—' : formatDate(openedOn));
    },
  ),
  AppTableColumn(
    id: 'status',
    label: 'Estado',
    cellBuilder: (context, row) => _StatusCell(row.status),
  ),
];

final _cardColumns = <AppTableColumn<ReportCard>>[
  AppTableColumn(
    id: 'card',
    label: 'Tarjeta',
    cellBuilder: (context, row) => AppTableCell(
      value: '${row.network} ${maskAccount(row.last4)}',
      meta: row.type.label,
      leadingIcon: row.type.icon,
    ),
  ),
  AppTableColumn(
    id: 'account',
    label: 'Cuenta asociada',
    cellBuilder: (context, row) {
      final last4 = row.accountLast4;
      return AppTableCell(value: last4 == null ? '—' : maskAccount(last4));
    },
  ),
  AppTableColumn(
    id: 'limit',
    label: 'Cupo',
    numeric: true,
    cellBuilder: (context, row) {
      final limit = row.creditLimit;
      final currency = row.currency;
      return AppTableCell(
        numeric: true,
        value: limit == null || currency == null
            ? '—'
            : formatMoney(limit, currency),
      );
    },
  ),
  AppTableColumn(
    id: 'expires',
    label: 'Vence',
    cellBuilder: (context, row) =>
        AppTableCell(value: formatDate(row.expiresOn)),
  ),
  AppTableColumn(
    id: 'status',
    label: 'Estado',
    cellBuilder: (context, row) => _StatusCell(row.status),
  ),
];

final _deviceColumns = <AppTableColumn<ReportDevice>>[
  AppTableColumn(
    id: 'device',
    label: 'Dispositivo',
    cellBuilder: (context, row) => AppTableCell(
      value: row.name ?? row.type.label,
      meta: row.system,
      leadingIcon: row.type.icon,
    ),
  ),
  AppTableColumn(
    id: 'first',
    label: 'Primer uso',
    cellBuilder: (context, row) =>
        AppTableCell(value: formatDate(row.firstSeenAt)),
  ),
  AppTableColumn(
    id: 'last',
    label: 'Último uso',
    cellBuilder: (context, row) =>
        AppTableCell(value: formatDateTime(row.lastSeenAt)),
  ),
  AppTableColumn(
    id: 'trust',
    label: 'Confianza',
    cellBuilder: (context, row) => Align(
      alignment: Alignment.centerLeft,
      child: row.isTrusted
          ? const StatusBadge(
              label: 'De confianza',
              tone: StatusTone.success,
              icon: AppIcons.shield,
              small: true,
            )
          : const StatusBadge(
              label: 'Nuevo',
              tone: StatusTone.warning,
              icon: AppIcons.warning,
              small: true,
            ),
    ),
  ),
];

class _StatusCell extends StatelessWidget {
  const _StatusCell(this.status);

  final ProductStatus status;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: StatusBadge(
      label: status.label,
      tone: status.tone,
      icon: status.icon,
      small: true,
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.count,
    required this.child,
  });

  final String title;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) => AppPanel(
    title: title,
    subtitle: count == 1 ? '1 registro' : '$count registros',
    padding: EdgeInsets.zero,
    child: child,
  );
}
