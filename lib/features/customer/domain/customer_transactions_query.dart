import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_transactions_query.freezed.dart';

/// Columns the A-02 table can sort by.
enum CustomerTransactionsSort { date, amount }

/// Account filter, sort and page of the A-02 table (HU-03). The date range is shared
/// with the report and lives in its own provider.
@freezed
abstract class CustomerTransactionsQuery with _$CustomerTransactionsQuery {
  const factory CustomerTransactionsQuery({
    /// One account of the customer. Null means all of them.
    String? accountId,
    @Default(CustomerTransactionsSort.date) CustomerTransactionsSort sort,
    @Default(false) bool ascending,
    @Default(1) int page,
    @Default(25) int pageSize,
  }) = _CustomerTransactionsQuery;

  const CustomerTransactionsQuery._();

  static const pageSizes = [25, 50, 100];

  /// First row of the page, for `.range(from, to)`.
  int get from => (page - 1) * pageSize;

  /// Last row of the page, for `.range(from, to)`.
  int get to => from + pageSize - 1;
}
