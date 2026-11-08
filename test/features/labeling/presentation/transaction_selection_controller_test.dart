import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/labeling/domain/transaction_selection.dart';
import 'package:monedasegura/features/labeling/presentation/controllers/transaction_selection_controller.dart';

void main() {
  late ProviderContainer container;
  final provider = selectedTransactionsProvider(SelectionScope.transactions);

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    // The provider is autoDispose: the listener keeps it alive as a table would.
    container.listen(provider, (_, _) {});
  });

  SelectedTransactionsNotifier notifier() => container.read(provider.notifier);
  TransactionSelection selection() => container.read(provider);

  const unlabeled = SelectedTransaction(id: 1, isLabeled: false);
  const labeled = SelectedTransaction(id: 2, isLabeled: true);
  const otherLabeled = SelectedTransaction(id: 3, isLabeled: true);

  test('starts empty', () {
    expect(selection().isEmpty, isTrue);
    expect(selection().count, 0);
    expect(selection().labeledCount, 0);
  });

  test('select adds a transaction and keeps whether it is labeled', () {
    notifier()
      ..select(unlabeled)
      ..select(labeled);

    expect(selection().ids, {1, 2});
    expect(selection().count, 2);
    expect(selection().labeledCount, 1);
    expect(selection().contains(2), isTrue);
  });

  test('selecting the same transaction twice counts it once', () {
    notifier()
      ..select(labeled)
      ..select(labeled);

    expect(selection().count, 1);
  });

  test('deselect removes only that transaction', () {
    notifier()
      ..selectAll([unlabeled, labeled])
      ..deselect(1);

    expect(selection().ids, {2});
    expect(selection().labeledCount, 1);
  });

  test('selectAll adds a whole page and deselectAll removes it', () {
    notifier().selectAll([unlabeled, labeled, otherLabeled]);

    expect(selection().count, 3);
    expect(selection().labeledCount, 2);

    notifier().deselectAll([2, 3]);

    expect(selection().ids, {1});
  });

  test('clear empties the selection', () {
    notifier()
      ..selectAll([unlabeled, labeled])
      ..clear();

    expect(selection().isEmpty, isTrue);
    expect(selection().labeledCount, 0);
  });

  test('setPage applies the checked rows of a page and keeps other pages', () {
    // Checked on an earlier page.
    notifier().select(const SelectedTransaction(id: 99, isLabeled: false));

    notifier().setPage([unlabeled, labeled, otherLabeled], {1, 3});
    expect(selection().ids, {99, 1, 3});

    // Unchecking a row of this page, as the table reports it.
    notifier().setPage([unlabeled, labeled, otherLabeled], {3});
    expect(selection().ids, {99, 3});
  });

  test('refresh updates whether selected rows are labeled, never selects', () {
    notifier().select(unlabeled);

    notifier().refresh([
      const SelectedTransaction(id: 1, isLabeled: true),
      labeled,
    ]);

    expect(selection().ids, {1});
    expect(selection().labeledCount, 1);
  });

  test('an unchanged selection does not notify', () {
    var notifications = 0;
    container.listen(provider, (_, _) => notifications++);

    notifier()
      ..select(unlabeled)
      ..select(unlabeled)
      ..deselect(42)
      ..clear()
      ..clear();

    expect(notifications, 2);
  });

  test('each table keeps its own selection', () {
    final customer = selectedTransactionsProvider(
      SelectionScope.customer('c-1'),
    );
    container.listen(customer, (_, _) {});

    notifier().select(unlabeled);
    container.read(customer.notifier).select(labeled);

    expect(selection().ids, {1});
    expect(container.read(customer).ids, {2});
  });
}
