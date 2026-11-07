import '../../../core/domain/catalog_models.dart';
import '../../../core/domain/channel.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/page_result.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../domain/transaction_country.dart';
import '../domain/transaction_row.dart';
import '../domain/transactions_query.dart';
import 'transactions_repository.dart';

/// Offline list for `USE_FAKE_DATA=true` and tests. It stands in for the database, so
/// this is the only place where a list is filtered in memory. Like the view, its rows
/// have no country until [countries] gives it.
class FakeTransactionsRepository implements TransactionsRepository {
  FakeTransactionsRepository(this._localWrites, {List<TransactionRow>? rows})
    : _rows = rows ?? _prototypeRows;

  final LocalWritesStore _localWrites;
  final List<TransactionRow> _rows;

  @override
  Future<PageResult<TransactionRow>> fetchPage(
    TransactionsQuery query, {
    required List<CatalogCountry> countries,
  }) async {
    final countryCode = query.countryCode;
    final currencyCode = countryCode == null
        ? null
        : currencyOfCountry(countryCode, countries);
    if (countryCode != null && currencyCode == null) {
      return const PageResult(items: [], total: 0);
    }
    final matching =
        _rows.where((row) => _matches(row, query, currencyCode)).toList()
          ..sort((a, b) => _compare(a, b, query));
    final items = matching.skip(query.from).take(query.pageSize).toList();
    return PageResult(
      items: withLocalLabels(withCountries(items, countries), _localWrites),
      total: matching.length,
    );
  }

  static bool _matches(
    TransactionRow row,
    TransactionsQuery query,
    String? currencyCode,
  ) {
    final search = query.search.trim().toLowerCase();
    final dateFrom = query.dateFrom;
    final dateTo = query.dateTo;
    return (search.isEmpty || row.code.toLowerCase().contains(search)) &&
        (dateFrom == null || !row.occurredAt.isBefore(dateFrom)) &&
        (dateTo == null ||
            row.occurredAt.isBefore(dateTo.add(const Duration(days: 1)))) &&
        (currencyCode == null || row.currency.code == currencyCode) &&
        (query.channelCode == null ||
            row.channel.dbValue == query.channelCode) &&
        (query.labelStatus == null || row.labelStatus == query.labelStatus) &&
        (!query.withAiAlert || row.hasAiAlert);
  }

  static int _compare(
    TransactionRow a,
    TransactionRow b,
    TransactionsQuery query,
  ) {
    if (query.sort == TransactionsSort.score) {
      // Rows without a score go last in both directions, as `nullsFirst: false`.
      final scoreA = a.alertScore;
      final scoreB = b.alertScore;
      if (scoreA == null || scoreB == null) {
        if (scoreA == scoreB) return b.id.compareTo(a.id);
        return scoreA == null ? 1 : -1;
      }
    }
    final order = switch (query.sort) {
      TransactionsSort.date => a.occurredAt.compareTo(b.occurredAt),
      TransactionsSort.amount => a.amount.compareTo(b.amount),
      TransactionsSort.score => a.alertScore!.compareTo(b.alertScore!),
    };
    if (order == 0) return b.id.compareTo(a.id);
    return query.ascending ? order : -order;
  }
}

final _prototypeRows = [
  TransactionRow(
    id: 48219,
    code: 'TX-48219',
    occurredAt: DateTime(2026, 3, 19, 22, 41),
    customerId: '00000000-0000-4000-8000-000000000001',
    sourceAccountId: '00000000-0000-4000-9000-000000000001',
    destinationAccountId: '00000000-0000-4000-9000-000000000101',
    type: TransactionType.transfer,
    channel: Channel.pse,
    amount: 1900000,
    currency: Currency.cop,
    alertScore: 92,
    isLabeled: false,
  ),
  TransactionRow(
    id: 48220,
    code: 'TX-48220',
    occurredAt: DateTime(2026, 3, 19, 18, 5),
    customerId: '00000000-0000-4000-8000-000000000002',
    sourceAccountId: '00000000-0000-4000-9000-000000000002',
    type: TransactionType.purchase,
    channel: Channel.pos,
    amount: 125500,
    currency: Currency.mxn,
    alertScore: 74,
    isLabeled: true,
    verdict: Verdict.fraud,
  ),
  TransactionRow(
    id: 48221,
    code: 'TX-48221',
    occurredAt: DateTime(2026, 3, 18, 9, 30),
    customerId: '00000000-0000-4000-8000-000000000003',
    sourceAccountId: '00000000-0000-4000-9000-000000000003',
    destinationAccountId: '00000000-0000-4000-9000-000000000103',
    type: TransactionType.transfer,
    channel: Channel.yape,
    amount: 1500,
    currency: Currency.pen,
    isLabeled: true,
    verdict: Verdict.notFraud,
  ),
  TransactionRow(
    id: 48222,
    code: 'TX-48222',
    occurredAt: DateTime(2026, 3, 17, 15, 12),
    customerId: '00000000-0000-4000-8000-000000000004',
    sourceAccountId: '00000000-0000-4000-9000-000000000004',
    type: TransactionType.withdrawal,
    channel: Channel.atm,
    amount: 250000,
    currency: Currency.clp,
    alertScore: 45,
    isLabeled: false,
  ),
  TransactionRow(
    id: 48223,
    code: 'TX-48223',
    occurredAt: DateTime(2026, 3, 16, 11, 48),
    customerId: '00000000-0000-4000-8000-000000000005',
    sourceAccountId: '00000000-0000-4000-9000-000000000005',
    type: TransactionType.payment,
    channel: Channel.web,
    amount: 84000,
    currency: Currency.ars,
    isLabeled: false,
  ),
  TransactionRow(
    id: 48224,
    code: 'TX-48224',
    occurredAt: DateTime(2026, 3, 15, 20, 17),
    customerId: '00000000-0000-4000-8000-000000000006',
    destinationAccountId: '00000000-0000-4000-9000-000000000006',
    type: TransactionType.credit,
    channel: Channel.pix,
    amount: 12400,
    currency: Currency.brl,
    isLabeled: true,
    verdict: Verdict.uncertain,
  ),
];
