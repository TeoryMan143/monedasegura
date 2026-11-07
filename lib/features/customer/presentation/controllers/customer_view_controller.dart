import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/page_result.dart';
import '../../data/customer_repository.dart';
import '../../domain/customer_transaction.dart';
import '../../domain/customer_transactions_query.dart';
import '../../domain/customer_view.dart';
import '../../domain/range_totals.dart';
import 'customer_range_controller.dart';

/// A failed request shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The customer, their accounts and pending alerts: the part of A-02 that does not
/// depend on the range (HU-03).
final customerViewProvider = FutureProvider.autoDispose
    .family<CustomerView, String>(
      (ref, customerId) =>
          ref.watch(customerRepositoryProvider).fetchCustomer(customerId),
      retry: _noAutoRetry,
      name: 'customerViewProvider',
    );

/// When a transaction happened, so the view can move its range to show it (`?tx=`).
final customerTransactionDateProvider = FutureProvider.autoDispose
    .family<DateTime?, int>(
      (ref, transactionId) => ref
          .watch(customerRepositoryProvider)
          .fetchTransactionDate(transactionId),
      retry: _noAutoRetry,
      name: 'customerTransactionDateProvider',
    );

/// Account filter, sort and page of the A-02 table, one per customer (HU-03).
final customerTransactionsQueryProvider = NotifierProvider.autoDispose
    .family<
      CustomerTransactionsQueryNotifier,
      CustomerTransactionsQuery,
      String
    >(
      CustomerTransactionsQueryNotifier.new,
      name: 'customerTransactionsQueryProvider',
    );

/// Every change except [setPage] goes back to page 1, and so does a new date range.
class CustomerTransactionsQueryNotifier
    extends Notifier<CustomerTransactionsQuery> {
  CustomerTransactionsQueryNotifier(this.customerId);

  final String customerId;

  @override
  CustomerTransactionsQuery build() {
    ref.listen(customerDateRangeProvider(customerId), (_, _) {
      state = state.copyWith(page: 1);
    });
    return const CustomerTransactionsQuery();
  }

  void setAccount(String? accountId) =>
      state = state.copyWith(accountId: accountId, page: 1);

  void setSort(CustomerTransactionsSort sort, {bool ascending = false}) =>
      state = state.copyWith(sort: sort, ascending: ascending, page: 1);

  void setPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
  }

  void setPageSize(int pageSize) {
    assert(
      CustomerTransactionsQuery.pageSizes.contains(pageSize),
      'Unsupported $pageSize',
    );
    state = state.copyWith(pageSize: pageSize, page: 1);
  }
}

/// The page of the A-02 table: the customer's transactions in the range (HU-03).
final customerTransactionsPageProvider = FutureProvider.autoDispose
    .family<PageResult<CustomerTransaction>, String>(
      (ref, customerId) async {
        final repository = ref.watch(customerRepositoryProvider);
        final range = ref.watch(customerDateRangeProvider(customerId));
        final query = ref.watch(customerTransactionsQueryProvider(customerId));
        final customer = await ref.watch(
          customerViewProvider(customerId).future,
        );
        return repository.fetchPage(customer, range, query);
      },
      retry: _noAutoRetry,
      name: 'customerTransactionsPageProvider',
    );

/// Labeled / total in the range, for the progress bar of the header (HU-03).
final customerLabelProgressProvider = FutureProvider.autoDispose
    .family<LabelProgress, String>(
      (ref, customerId) async {
        final repository = ref.watch(customerRepositoryProvider);
        final range = ref.watch(customerDateRangeProvider(customerId));
        final customer = await ref.watch(
          customerViewProvider(customerId).future,
        );
        return repository.fetchProgress(customer, range);
      },
      retry: _noAutoRetry,
      name: 'customerLabelProgressProvider',
    );

/// Money in, money out and net per currency in the range, for the chosen account
/// (HU-03). Changing page or sort does not ask for them again.
final customerRangeTotalsProvider = FutureProvider.autoDispose
    .family<List<RangeTotals>, String>(
      (ref, customerId) {
        final repository = ref.watch(customerRepositoryProvider);
        final range = ref.watch(customerDateRangeProvider(customerId));
        final accountId = ref.watch(
          customerTransactionsQueryProvider(customerId)
              .select((query) => query.accountId),
        );
        return repository.fetchTotals(customerId, range, accountId: accountId);
      },
      retry: _noAutoRetry,
      name: 'customerRangeTotalsProvider',
    );
