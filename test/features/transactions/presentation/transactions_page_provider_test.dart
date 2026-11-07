import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/country.dart';
import 'package:monedasegura/core/domain/label_status.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/transactions/data/fake_transactions_repository.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';
import 'package:monedasegura/features/transactions/domain/transactions_query.dart';
import 'package:monedasegura/features/transactions/presentation/controllers/transactions_page_controller.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(
          FakeTransactionsRepository(LocalWritesStore()),
        ),
        catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<List<String>> codes(TransactionsQuery query) async {
    final subscription = container.listen(
      transactionsPageProvider(query).future,
      (_, _) {},
    );
    addTearDown(subscription.close);
    final page = await subscription.read();
    return [for (final row in page.items) row.code];
  }

  test('loads the page of the query with the total of the filter', () async {
    final subscription = container.listen(
      transactionsPageProvider(const TransactionsQuery()).future,
      (_, _) {},
    );
    addTearDown(subscription.close);

    final page = await subscription.read();

    expect(page.items, hasLength(6));
    expect(page.total, 6);
  });

  test('every row gets its country from the catalog', () async {
    final subscription = container.listen(
      transactionsPageProvider(const TransactionsQuery()).future,
      (_, _) {},
    );
    addTearDown(subscription.close);

    final page = await subscription.read();

    expect(page.items.first.country, Country.colombia);
    expect(page.items.map((row) => row.country), everyElement(isNotNull));
  });

  test('two queries are two pages', () async {
    expect(await codes(const TransactionsQuery(countryCode: 'CL')), [
      'TX-48222',
    ]);
    expect(
      await codes(const TransactionsQuery(labelStatus: LabelStatus.labeled)),
      ['TX-48220', 'TX-48221', 'TX-48224'],
    );
  });

  test('the search finds by customer, account digits or ID', () async {
    expect(await codes(const TransactionsQuery(search: 'quispe')), [
      'TX-48221',
    ]);
    expect(await codes(const TransactionsQuery(search: '1164')), ['TX-48222']);
    expect(await codes(const TransactionsQuery(search: 'TX-48224')), [
      'TX-48224',
    ]);
    expect(await codes(const TransactionsQuery(search: 'ana 9999')), isEmpty);
  });

  test('a country outside the catalog has no transactions', () async {
    expect(await codes(const TransactionsQuery(countryCode: 'US')), isEmpty);
  });

  test('the highest score goes first and rows without score last', () async {
    final result = await codes(
      const TransactionsQuery(sort: TransactionsSort.score),
    );

    expect(result.take(3), ['TX-48219', 'TX-48220', 'TX-48222']);
    expect(result, hasLength(6));
  });
}
