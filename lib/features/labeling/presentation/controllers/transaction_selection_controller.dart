import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/transaction_selection.dart';

/// The table a selection belongs to. A-01 and each customer's A-02 keep their own.
abstract final class SelectionScope {
  /// A-01, the list of every transaction.
  static const transactions = 'transactions';

  /// A-02, the table of [customerId].
  static String customer(String customerId) => 'customer:$customerId';
}

/// The transactions checked in the table of a [SelectionScope], for the bulk
/// classification (HU-05).
final selectedTransactionsProvider = NotifierProvider.autoDispose
    .family<SelectedTransactionsNotifier, TransactionSelection, String>(
      SelectedTransactionsNotifier.new,
      name: 'selectedTransactionsProvider',
    );

/// Checks and unchecks transactions. The table decides when to [clear]: the selection
/// does not know its filters.
class SelectedTransactionsNotifier extends Notifier<TransactionSelection> {
  SelectedTransactionsNotifier(this.scope);

  final String scope;

  @override
  TransactionSelection build() => const TransactionSelection();

  void select(SelectedTransaction transaction) => selectAll([transaction]);

  void deselect(int id) => deselectAll([id]);

  /// Adds [transactions], e.g. the rows of a page from the header checkbox.
  void selectAll(Iterable<SelectedTransaction> transactions) =>
      _update((selected) {
        for (final transaction in transactions) {
          selected[transaction.id] = transaction.isLabeled;
        }
      });

  void deselectAll(Iterable<int> ids) =>
      _update((selected) => ids.forEach(selected.remove));

  void clear() {
    if (state.isEmpty) return;
    state = const TransactionSelection();
  }

  /// What a table reports after a click: of the rows of its [page], the ones in
  /// [checked] are selected and the rest are not. Rows of other pages stay as they are.
  void setPage(Iterable<SelectedTransaction> page, Set<Object> checked) =>
      _update((selected) {
        for (final transaction in page) {
          if (checked.contains(transaction.id)) {
            selected[transaction.id] = transaction.isLabeled;
          } else {
            selected.remove(transaction.id);
          }
        }
      });

  /// Updates whether the selected rows of a freshly loaded [page] are labeled, e.g.
  /// after one of them was labeled in the classification panel. Never selects a row.
  void refresh(Iterable<SelectedTransaction> page) => _update((selected) {
    for (final transaction in page) {
      if (selected.containsKey(transaction.id)) {
        selected[transaction.id] = transaction.isLabeled;
      }
    }
  });

  void _update(void Function(Map<int, bool> selected) change) {
    final selected = Map<int, bool>.of(state.labeledById);
    change(selected);
    final next = TransactionSelection(labeledById: selected);
    // Equal selections do not notify: the tables do not rebuild for nothing.
    if (next != state) state = next;
  }
}
