import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/domain/customer_transactions_query.dart';
import 'package:monedasegura/features/customer/domain/date_range.dart';
import 'package:monedasegura/features/customer/presentation/controllers/customer_range_controller.dart';
import 'package:monedasegura/features/customer/presentation/controllers/customer_view_controller.dart';

const _id = FakeCustomerRepository.customerId;

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        customerRepositoryProvider.overrideWithValue(
          FakeCustomerRepository(LocalWritesStore()),
        ),
      ],
    );
    addTearDown(container.dispose);
    // Both are autoDispose: the listeners keep them alive as the screen would.
    container
      ..listen(customerDateRangeProvider(_id), (_, _) {})
      ..listen(customerTransactionsQueryProvider(_id), (_, _) {});
  });

  DateRange range() => container.read(customerDateRangeProvider(_id));
  CustomerTransactionsQuery query() =>
      container.read(customerTransactionsQueryProvider(_id));
  CustomerTransactionsQueryNotifier queryNotifier() =>
      container.read(customerTransactionsQueryProvider(_id).notifier);

  test('the view opens on the last 30 days, ending today', () {
    expect(range().days, defaultRangeDays);
    expect(range().contains(DateTime.now()), isTrue);
  });

  test('a new range goes back to page 1', () {
    queryNotifier().setPage(3);

    container
        .read(customerDateRangeProvider(_id).notifier)
        .setRange(
          DateRange(from: DateTime(2026, 3), to: DateTime(2026, 3, 15)),
        );

    expect(query().page, 1);
  });

  test('the account filter, the sort and the page size go back to page 1', () {
    queryNotifier()
      ..setPage(3)
      ..setAccount('a1');
    expect(query().accountId, 'a1');
    expect(query().page, 1);

    queryNotifier()
      ..setPage(3)
      ..setSort(CustomerTransactionsSort.amount, ascending: true);
    expect(query().page, 1);

    queryNotifier()
      ..setPage(3)
      ..setPageSize(50);
    expect(query().page, 1);
  });

  test('showing a day outside the range moves it, keeping its length', () {
    final notifier = container.read(customerDateRangeProvider(_id).notifier);
    final before = range();

    notifier.show(DateTime.now());
    expect(range(), before);

    final old = DateTime.now().subtract(const Duration(days: 90));
    notifier.show(old);
    expect(range().contains(old), isTrue);
    expect(range().days, before.days);
  });

  test('the range is shared: one per customer', () {
    container
        .read(customerDateRangeProvider(_id).notifier)
        .setRange(
          DateRange(from: DateTime(2026, 3), to: DateTime(2026, 3, 15)),
        );

    expect(
      container.read(customerDateRangeProvider('other')).days,
      defaultRangeDays,
    );
  });

  test('totals and progress follow the range and the account', () async {
    Future<T> read<T>(ProviderListenable<Future<T>> provider) {
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      return subscription.read();
    }

    final all = await read(customerRangeTotalsProvider(_id).future);
    final progress = await read(customerLabelProgressProvider(_id).future);
    // The payroll credit plus the transfer between two own accounts, which counts in and
    // out, as the customer_range_totals RPC does.
    expect(all.single.totalIn, 4800000 + 300000);
    expect(progress.total, 8);
    expect(progress.labeled, 5);

    queryNotifier().setAccount('00000000-0000-4000-9000-000000000301');
    final wallet = await read(customerRangeTotalsProvider(_id).future);
    expect(wallet.single.totalOut, 249900);
  });
}
