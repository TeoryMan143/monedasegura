import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/label_status.dart';
import '../../../../core/domain/page_result.dart';
import '../../../../core/domain/transaction_type.dart';
import '../../../../core/formatting/account_mask.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/transaction_row.dart';
import '../../domain/transactions_query.dart';
import '../controllers/transactions_page_controller.dart';
import '../controllers/transactions_query_controller.dart';

const _dateWidth = 104.0;
const _amountWidth = 168.0;
const _scoreWidth = 96.0;
const _labelWidth = 160.0;

/// Opens a transaction: the customer view with that transaction selected.
typedef OpenTransaction = void Function(String customerId, int transactionId);

/// The table of A-01 and its pagination (HU-02), with loading (E-01), empty and no
/// results (E-02) and error states.
///
/// A click on a row calls [onOpen]; the checkbox only selects. The selection is cleared
/// when the query changes, because the rows are no longer the same.
class TransactionsTable extends ConsumerStatefulWidget {
  const TransactionsTable({required this.onOpen, super.key});

  final OpenTransaction onOpen;

  @override
  ConsumerState<TransactionsTable> createState() => _TransactionsTableState();
}

class _TransactionsTableState extends ConsumerState<TransactionsTable> {
  Set<Object> _selected = {};

  void _open(TransactionRow row) {
    final customerId = row.customerId;
    if (customerId != null) widget.onOpen(customerId, row.id);
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(transactionsQueryProvider);
    final notifier = ref.read(transactionsQueryProvider.notifier);
    final page = ref.watch(transactionsPageProvider(query));
    ref.listen(transactionsQueryProvider, (_, _) {
      if (_selected.isNotEmpty) setState(() => _selected = {});
    });

    final sort = AppTableSort(
      columnId: query.sort.name,
      direction: query.ascending
          ? SortDirection.ascending
          : SortDirection.descending,
    );

    Widget table({
      List<TransactionRow> rows = const [],
      bool loading = false,
    }) => AppDataTable<TransactionRow>(
      columns: _columns,
      rows: rows,
      rowKey: (row) => row.id,
      loading: loading,
      sort: sort,
      onSort: (columnId) {
        final next = sort.toggle(columnId);
        notifier.setSort(
          TransactionsSort.values.byName(next.columnId),
          ascending: next.direction == SortDirection.ascending,
        );
      },
      onRowTap: _open,
      selectedKeys: _selected,
      onSelectionChanged: (keys) => setState(() => _selected = keys),
      isFlagged: (row) => row.hasAiAlert,
      empty: _EmptyTransactions(query: query),
      rowSemanticLabel: (row) =>
          'Abrir ${row.code}${row.customerName == null ? '' : ' de ${row.customerName}'}',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ScreenState<PageResult<TransactionRow>>(
            value: page,
            onRetry: () => ref.invalidate(transactionsPageProvider(query)),
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
            pageSizes: TransactionsQuery.pageSizes,
            onPageChanged: notifier.setPage,
            onPageSizeChanged: notifier.setPageSize,
          )
        else
          const _PaginationPlaceholder(),
      ],
    );
  }
}

final List<AppTableColumn<TransactionRow>> _columns = [
  AppTableColumn(
    id: TransactionsSort.date.name,
    label: 'Fecha',
    width: _dateWidth,
    sortable: true,
    cellBuilder: (context, row) => AppTableCell(
      value: formatShortDate(row.occurredAt),
      meta: formatTime(row.occurredAt),
    ),
  ),
  AppTableColumn(
    id: 'customer',
    label: 'Cliente / cuenta',
    flex: 2,
    minWidth: 200,
    cellBuilder: (context, row) => AppTableCell(
      value: row.customerName ?? 'Sin cliente del banco',
      meta: _accountMeta(row),
    ),
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
    id: TransactionsSort.amount.name,
    label: 'Monto',
    width: _amountWidth,
    numeric: true,
    sortable: true,
    cellBuilder: (context, row) {
      final credit = row.type == TransactionType.credit;
      return AppTableCell(
        numeric: true,
        value: credit
            ? formatSignedMoney(row.amount, row.currency, withCode: false)
            : formatMoney(row.amount, row.currency, withCode: false),
        meta: row.currency.code,
        valueColor: credit ? StatusTone.success.text : null,
      );
    },
  ),
  AppTableColumn(
    id: TransactionsSort.score.name,
    label: 'Alerta IA',
    width: _scoreWidth,
    cellBuilder: (context, row) => switch (row.alertScore) {
      final score? => ScoreBadge(score: score),
      null => const _NoValue(),
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

/// «Ah •••• 4417 · CO»: account type, masked digits and country, whichever are known.
String? _accountMeta(TransactionRow row) {
  final last4 = row.accountLast4;
  final account = last4 == null
      ? null
      : [?row.accountType?.abbreviation, maskAccount(last4)].join(' ');
  final parts = [?account, ?row.country?.code];
  return parts.isEmpty ? null : parts.join(' · ');
}

/// «—» in a cell without a value, e.g. a transaction without an AI alert.
class _NoValue extends StatelessWidget {
  const _NoValue();

  @override
  Widget build(BuildContext context) => Text(
    '—',
    style: AppText.bodyM.copyWith(color: AppColors.textTertiary),
    semanticsLabel: 'Sin alerta',
  );
}

/// E-02: what the empty table says depends on why it is empty.
class _EmptyTransactions extends ConsumerWidget {
  const _EmptyTransactions({required this.query});

  final TransactionsQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionsQueryProvider.notifier);
    if (query.labelStatus == LabelStatus.unlabeled) {
      return EmptyState(
        title: 'No quedan transacciones sin etiquetar',
        message:
            'Todas las transacciones que coinciden con los filtros ya tienen '
            'etiqueta. Quita el filtro «Etiqueta: Sin etiquetar» o revisa la '
            'bandeja de alertas.',
        actionLabel: 'Quitar filtro',
        onAction: () => notifier.removeFilter(TransactionsFilter.labelStatus),
      );
    }
    if (query.activeFilters.isNotEmpty) {
      return EmptyState.noResults(onClearFilters: notifier.clearFilters);
    }
    return const EmptyState(
      title: 'No hay transacciones',
      message: 'Cuando el banco registre transacciones aparecerán aquí.',
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
