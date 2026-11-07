import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/transactions_query.dart';

/// Search, filters, sort and page of the A-01 list (HU-02).
final transactionsQueryProvider =
    NotifierProvider.autoDispose<TransactionsQueryNotifier, TransactionsQuery>(
      TransactionsQueryNotifier.new,
      name: 'transactionsQueryProvider',
    );

/// Every change except [setPage] goes back to page 1.
class TransactionsQueryNotifier extends Notifier<TransactionsQuery> {
  @override
  TransactionsQuery build() => const TransactionsQuery();

  /// Applies [update] to the filters, e.g.
  /// `setFilter((query) => query.copyWith(countryCode: 'CO'))`.
  void setFilter(TransactionsQuery Function(TransactionsQuery) update) =>
      state = update(state).copyWith(page: 1);

  void removeFilter(TransactionsFilter filter) =>
      state = state.without(filter).copyWith(page: 1);

  /// Removes the search and every filter. Sort and page size stay.
  void clearFilters() => state = TransactionsQuery(
    sort: state.sort,
    ascending: state.ascending,
    pageSize: state.pageSize,
  );

  void setSort(TransactionsSort sort, {bool ascending = false}) =>
      state = state.copyWith(sort: sort, ascending: ascending, page: 1);

  void setPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
  }

  void setPageSize(int pageSize) {
    assert(
      TransactionsQuery.pageSizes.contains(pageSize),
      'Unsupported $pageSize',
    );
    state = state.copyWith(pageSize: pageSize, page: 1);
  }
}
