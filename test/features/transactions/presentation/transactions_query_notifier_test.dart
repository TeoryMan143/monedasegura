import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/label_status.dart';
import 'package:monedasegura/features/transactions/domain/transactions_query.dart';
import 'package:monedasegura/features/transactions/presentation/controllers/transactions_query_controller.dart';

void main() {
  late ProviderContainer container;
  late TransactionsQueryNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    // The provider is autoDispose: the listener keeps it alive as a screen would.
    container.listen(transactionsQueryProvider, (_, _) {});
    notifier = container.read(transactionsQueryProvider.notifier);
  });

  TransactionsQuery query() => container.read(transactionsQueryProvider);

  test('starts on the newest transactions, page 1 of 25, without filters', () {
    expect(query().sort, TransactionsSort.date);
    expect(query().ascending, isFalse);
    expect(query().page, 1);
    expect(query().pageSize, 25);
    expect(query().activeFilters, isEmpty);
  });

  test('setPage moves only the page and ignores pages before the first', () {
    notifier.setFilter((query) => query.copyWith(countryCode: 'CO'));
    notifier.setPage(3);

    expect(query().page, 3);
    expect(query().countryCode, 'CO');

    notifier.setPage(0);

    expect(query().page, 3);
  });

  test('from and to give the range of the page', () {
    notifier.setPageSize(50);
    notifier.setPage(3);

    expect(query().from, 100);
    expect(query().to, 149);
  });

  test('a filter goes back to page 1', () {
    notifier.setPage(4);

    notifier.setFilter((query) => query.copyWith(countryCode: 'CO'));

    expect(query().countryCode, 'CO');
    expect(query().page, 1);
  });

  test('removing a filter goes back to page 1 and keeps the others', () {
    notifier.setFilter(
      (query) =>
          query.copyWith(countryCode: 'CO', labelStatus: LabelStatus.unlabeled),
    );
    notifier.setPage(4);

    notifier.removeFilter(TransactionsFilter.country);

    expect(query().countryCode, isNull);
    expect(query().labelStatus, LabelStatus.unlabeled);
    expect(query().page, 1);
  });

  test('each filter can be removed on its own', () {
    final filtered = TransactionsQuery(
      search: 'rojas',
      dateFrom: DateTime(2026, 3),
      dateTo: DateTime(2026, 3, 31),
      countryCode: 'CO',
      channelCode: 'PSE',
      labelStatus: LabelStatus.labeled,
      withAiAlert: true,
    );

    expect(filtered.activeFilters, TransactionsFilter.values);
    for (final filter in TransactionsFilter.values) {
      expect(filtered.without(filter).activeFilters, isNot(contains(filter)));
    }
  });

  test('clearing removes every filter and keeps sort and page size', () {
    notifier.setSort(TransactionsSort.amount, ascending: true);
    notifier.setPageSize(100);
    notifier.setFilter(
      (query) => query.copyWith(
        search: 'rojas',
        dateFrom: DateTime(2026, 3),
        dateTo: DateTime(2026, 3, 31),
        countryCode: 'CO',
        channelCode: 'PSE',
        labelStatus: LabelStatus.labeled,
        withAiAlert: true,
      ),
    );
    notifier.setPage(2);

    notifier.clearFilters();

    expect(query().activeFilters, isEmpty);
    expect(query().page, 1);
    expect(query().sort, TransactionsSort.amount);
    expect(query().ascending, isTrue);
    expect(query().pageSize, 100);
  });

  test('sorting and changing the page size go back to page 1', () {
    notifier.setPage(4);
    notifier.setSort(TransactionsSort.score);

    expect(query().sort, TransactionsSort.score);
    expect(query().ascending, isFalse);
    expect(query().page, 1);

    notifier.setPage(4);
    notifier.setPageSize(50);

    expect(query().pageSize, 50);
    expect(query().page, 1);
  });

  test('equal queries are equal, so the page family does not refetch', () {
    expect(
      const TransactionsQuery(countryCode: 'CO'),
      const TransactionsQuery(countryCode: 'CO'),
    );
  });
}
