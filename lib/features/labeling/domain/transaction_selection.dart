import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_selection.freezed.dart';

/// A transaction checked in a table for the bulk classification (HU-05).
@freezed
abstract class SelectedTransaction with _$SelectedTransaction {
  const factory SelectedTransaction({
    required int id,

    /// Whether it already had a label when it was checked.
    required bool isLabeled,
  }) = _SelectedTransaction;
}

/// The transactions checked in one table (A-01 or A-02), for A-03 (HU-05).
///
/// It keeps whether each one is labeled, so the confirmation can say «Se modificarán N
/// transacciones; M ya tenían etiqueta» without asking the database again.
@freezed
abstract class TransactionSelection with _$TransactionSelection {
  const factory TransactionSelection({
    /// Whether each selected transaction is labeled, by id.
    @Default(<int, bool>{}) Map<int, bool> labeledById,
  }) = _TransactionSelection;

  const TransactionSelection._();

  int get count => labeledById.length;

  bool get isEmpty => labeledById.isEmpty;

  Set<int> get ids => labeledById.keys.toSet();

  /// Selected transactions that already have a label: the edit overwrites them.
  int get labeledCount => labeledById.values.where((labeled) => labeled).length;

  bool contains(int id) => labeledById.containsKey(id);
}
