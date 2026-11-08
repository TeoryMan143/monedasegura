import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/label_status.dart';
import '../../../../core/domain/page_result.dart';
import '../../../../core/formatting/account_mask.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../../labeling/domain/transaction_selection.dart';
import '../../../labeling/presentation/bulk_selection_bar.dart';
import '../../../labeling/presentation/controllers/transaction_selection_controller.dart';
import '../../domain/customer_transaction.dart';
import '../../domain/customer_transactions_query.dart';
import '../../domain/customer_view.dart';
import '../../domain/range_totals.dart';
import '../controllers/customer_range_controller.dart';
import '../controllers/customer_view_controller.dart';

const _accountWidth = 140.0;
const _dateWidth = 104.0;
const _amountWidth = 168.0;
const _labelWidth = 160.0;
const _accountFilterWidth = 220.0;

/// The table card of A-02 (HU-03): the account filter, the count with the totals of the
/// range, the transactions of all the customer's accounts and the pagination.
///
/// A click on a row selects it ([onSelect]) and the classification panel (N-02, HU-04)
/// opens on it. The checkbox only selects rows for the bulk classification (HU-05).
///
/// The checked rows live in [selectedTransactionsProvider] with this customer's
/// [SelectionScope]. They survive a change of page, page size or sort, and are cleared
/// when the account or the date range changes, because the rows are no longer the same.
class CustomerTransactionsTable extends ConsumerWidget {
  const CustomerTransactionsTable({
    required this.customer,
    required this.selectedTransactionId,
    required this.onSelect,
    super.key,
  });

  final CustomerView customer;
  final int? selectedTransactionId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = customer.id;
    final queryProvider = customerTransactionsQueryProvider(id);
    final query = ref.watch(queryProvider);
    final notifier = ref.read(queryProvider.notifier);
    final page = ref.watch(customerTransactionsPageProvider(id));
    final selectionProvider = selectedTransactionsProvider(
      SelectionScope.customer(id),
    );
    final selection = ref.watch(selectionProvider);
    void clearSelection() => ref.read(selectionProvider.notifier).clear();
    ref
      ..listen(
        queryProvider.select((query) => query.accountId),
        (_, _) => clearSelection(),
      )
      ..listen(customerDateRangeProvider(id), (_, _) => clearSelection())
      ..listen(
        customerTransactionsPageProvider(id),
        (_, next) => ref
            .read(selectionProvider.notifier)
            .refresh(_selectable(next.value?.items ?? const [])),
      );

    final sort = AppTableSort(
      columnId: query.sort.name,
      direction: query.ascending
          ? SortDirection.ascending
          : SortDirection.descending,
    );
    final columns = _columns(customer);

    Widget table({
      List<CustomerTransaction> rows = const [],
      bool loading = false,
    }) => AppDataTable<CustomerTransaction>(
      columns: columns,
      rows: rows,
      rowKey: (row) => row.id,
      loading: loading,
      sort: sort,
      onSort: (columnId) {
        final next = sort.toggle(columnId);
        notifier.setSort(
          CustomerTransactionsSort.values.byName(next.columnId),
          ascending: next.direction == SortDirection.ascending,
        );
      },
      onRowTap: (row) => onSelect(row.id),
      activeKey: selectedTransactionId,
      selectedKeys: selection.ids,
      onSelectionChanged: (keys) =>
          ref.read(selectionProvider.notifier).setPage(_selectable(rows), keys),
      isFlagged: (row) => row.hasAiAlert,
      empty: _EmptyTransactions(customer: customer, query: query),
      rowSemanticLabel: (row) => 'Seleccionar ${row.code}',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Row(
            children: [
              AppDropdown<String?>(
                prefix: 'Cuenta',
                value: query.accountId,
                hint: 'Todas',
                width: _accountFilterWidth,
                items: [
                  const AppDropdownItem(value: null, label: 'Todas'),
                  for (final account in customer.accounts)
                    AppDropdownItem(
                      value: account.id,
                      label: _accountLabel(account),
                      detail: account.currency.code,
                    ),
                ],
                onChanged: notifier.setAccount,
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(child: _CountAndTotals(customerId: id)),
            ],
          ),
        ),
        BulkSelectionBar(
          scope: SelectionScope.customer(id),
          // As after N-02: the rows show their new label and the header its progress.
          onApplied: () => ref
            ..invalidate(customerTransactionsPageProvider(id))
            ..invalidate(customerLabelProgressProvider(id)),
        ),
        Expanded(
          child: ScreenState<PageResult<CustomerTransaction>>(
            value: page,
            onRetry: () => ref.invalidate(customerTransactionsPageProvider(id)),
            loading: table(loading: true),
            builder: (context, result) => table(rows: result.items),
          ),
        ),
        if (page case AsyncValue(:final value?))
          Pagination(
            page: query.page,
            pageSize: query.pageSize,
            totalCount: value.total,
            itemLabel: 'transacciones',
            pageSizes: CustomerTransactionsQuery.pageSizes,
            onPageChanged: notifier.setPage,
            onPageSizeChanged: notifier.setPageSize,
          )
        else
          const _PaginationPlaceholder(),
      ],
    );
  }
}

/// The rows of a page as the selection keeps them.
Iterable<SelectedTransaction> _selectable(List<CustomerTransaction> rows) =>
    rows.map(
      (row) => SelectedTransaction(id: row.id, isLabeled: row.isLabeled),
    );

String _accountLabel(CustomerAccount account) =>
    '${account.type.abbreviation} ${maskAccount(account.last4)}';

List<AppTableColumn<CustomerTransaction>> _columns(CustomerView customer) {
  final accounts = {
    for (final account in customer.accounts) account.id: account,
  };
  final ids = customer.accountIds;
  return [
    AppTableColumn(
      id: CustomerTransactionsSort.date.name,
      label: 'Fecha',
      width: _dateWidth,
      sortable: true,
      cellBuilder: (context, row) => AppTableCell(
        value: formatShortDate(row.occurredAt),
        meta: formatTime(row.occurredAt),
      ),
    ),
    AppTableColumn(
      id: 'account',
      label: 'Cuenta',
      width: _accountWidth,
      cellBuilder: (context, row) {
        final account = accounts[row.accountOf(ids)];
        return AppTableCell(
          value: account == null ? '—' : _accountLabel(account),
        );
      },
    ),
    AppTableColumn(
      id: 'type',
      label: 'Tipo · Canal',
      minWidth: 160,
      cellBuilder: (context, row) => AppTableCell(
        value: row.type.label,
        meta: row.channel.label,
        leadingIcon: row.hasAiAlert ? AppIcons.ai : null,
        leadingIconColor: StatusTone.info.solid,
      ),
    ),
    AppTableColumn(
      id: CustomerTransactionsSort.amount.name,
      label: 'Monto',
      width: _amountWidth,
      numeric: true,
      sortable: true,
      cellBuilder: (context, row) {
        final incoming = row.isIncomingFor(ids);
        return AppTableCell(
          numeric: true,
          value: incoming
              ? formatSignedMoney(row.amount, row.currency, withCode: false)
              : formatMoney(row.amount, row.currency, withCode: false),
          meta: row.currency.code,
          valueColor: incoming ? StatusTone.success.text : null,
        );
      },
    ),
    AppTableColumn(
      id: 'counterpart',
      label: 'Contraparte',
      minWidth: 180,
      cellBuilder: (context, row) => switch (row.merchantName) {
        final merchant? => AppTableCell(value: merchant),
        null => Text(
          '—',
          style: AppText.bodyM.copyWith(color: AppColors.textTertiary),
          semanticsLabel: 'Sin contraparte',
        ),
      },
    ),
    AppTableColumn(
      id: 'label',
      label: 'Etiqueta',
      width: _labelWidth,
      cellBuilder: (context, row) => switch (row.verdict) {
        final verdict? => StatusBadge(
          label: verdict.label,
          tone: verdict.tone,
          icon: verdict.icon,
          small: true,
        ),
        null => StatusBadge(
          label: LabelStatus.unlabeled.label,
          tone: LabelStatus.unlabeled.tone,
          icon: LabelStatus.unlabeled.icon,
          small: true,
        ),
      },
    ),
  ];
}

/// «60 transacciones · Entradas $ 12,4 M · Salidas $ 9,8 M · Neto +$ 2,6 M COP». The
/// totals come from the database for the whole range, never from the page.
class _CountAndTotals extends ConsumerWidget {
  const _CountAndTotals({required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(customerTransactionsPageProvider(customerId));
    final totals = ref.watch(customerRangeTotalsProvider(customerId));
    final numbers = NumberFormat.decimalPattern('es');
    final style = AppText.bodyS.copyWith(color: AppColors.textSecondary);

    if (page.hasError) return const SizedBox.shrink();
    if (!page.hasValue) return Text('Cargando transacciones…', style: style);
    final count = page.requireValue.total;
    final parts = [
      switch (count) {
        0 => '0 resultados',
        1 => '1 transacción',
        _ => '${numbers.format(count)} transacciones',
      },
      if (count > 0) ...?totals.value?.map(rangeTotalsText),
    ];
    return Text(
      parts.join(' · '),
      style: style,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Why the table is empty: the range, or the chosen account, has no transactions.
class _EmptyTransactions extends ConsumerWidget {
  const _EmptyTransactions({required this.customer, required this.query});

  final CustomerView customer;
  final CustomerTransactionsQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(customerDateRangeProvider(customer.id));
    final notifier = ref.read(
      customerTransactionsQueryProvider(customer.id).notifier,
    );
    if (customer.accounts.isEmpty) {
      return const EmptyState(
        title: 'El cliente no tiene cuentas',
        message: 'Sin cuentas en el banco no hay transacciones que mostrar.',
      );
    }
    return EmptyState(
      title: 'Sin transacciones en el rango',
      message:
          '${query.accountId == null ? 'El cliente' : 'Esta cuenta'} no tiene '
          'transacciones del ${formatDateRange(range.from, range.to)}. Prueba con '
          'un rango más amplio.',
      icon: AppIcons.calendar,
      actionLabel: query.accountId == null ? null : 'Ver todas las cuentas',
      onAction: query.accountId == null
          ? null
          : () => notifier.setAccount(null),
    );
  }
}

/// The pagination bar while the page loads or fails: same height, so nothing jumps.
class _PaginationPlaceholder extends StatelessWidget {
  const _PaginationPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    height: AppSizes.paginationBar,
    padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
    alignment: Alignment.centerLeft,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.borderSubtle)),
    ),
    child: Text(
      '—',
      style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
    ),
  );
}
