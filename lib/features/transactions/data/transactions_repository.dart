import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/domain/catalog_models.dart';
import '../../../core/domain/label_status.dart';
import '../../../core/domain/page_result.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_provider.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/transaction_country.dart';
import '../domain/transaction_row.dart';
import '../domain/transactions_query.dart';
import 'fake_transactions_repository.dart';

/// Reads the A-01 list from `v_transactions_list` (HU-02). Search, filters, sort and
/// pagination run in the database, never over a downloaded list.
///
/// The view has no country: [countries] (the `countries` catalog) turns the country
/// filter into a currency filter and gives each row its country.
class TransactionsRepository {
  TransactionsRepository(this._client, this._localWrites);

  final SupabaseClient _client;
  final LocalWritesStore _localWrites;

  static const _view = 'v_transactions_list';
  static const _columns =
      'id, code, occurred_at, customer_id, customer_name, account_last4, '
      'account_type, source_account_id, destination_account_id, type, '
      'channel_code, amount, currency_code, alert_score, is_labeled, verdict';

  Future<PageResult<TransactionRow>> fetchPage(
    TransactionsQuery query, {
    required List<CatalogCountry> countries,
  }) async {
    final (:known, :currencyCode) = currencyFilter(query, countries);
    if (!known) return const PageResult(items: [], total: 0);
    try {
      final request = _client.from(_view).select(_columns);
      final response = await _applyFilters(request, query, currencyCode)
          .order(
            _sortColumn(query.sort),
            ascending: query.ascending,
            nullsFirst: false,
          )
          // Rows with the same value keep their order from one page to the next.
          .order('id', ascending: false)
          .range(query.from, query.to)
          .count(CountOption.exact);
      final rows = [
        for (final row in response.data) TransactionRow.fromJson(row),
      ];
      return PageResult(
        items: withLocalLabels(withCountries(rows, countries), _localWrites),
        total: response.count,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Transactions without a label that match the filters of [query]: the «3.906 sin
  /// etiquetar» of the toolbar. Asks only for the count (a `HEAD` request), never rows.
  Future<int> countUnlabeled(
    TransactionsQuery query, {
    required List<CatalogCountry> countries,
  }) async {
    if (query.labelStatus == LabelStatus.labeled) return 0;
    final (:known, :currencyCode) = currencyFilter(query, countries);
    if (!known) return 0;
    try {
      final request = _client.from(_view).count(CountOption.exact);
      return await _applyFilters(
        request,
        query.copyWith(labelStatus: LabelStatus.unlabeled),
        currencyCode,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  PostgrestFilterBuilder<T> _applyFilters<T>(
    PostgrestFilterBuilder<T> request,
    TransactionsQuery query,
    String? currencyCode,
  ) {
    // Every word must match the customer, the account digits or the transaction ID.
    for (final word in _searchWords(query.search)) {
      request = request.or(
        'customer_name.ilike.*$word*,account_last4.ilike.*$word*,'
        'code.ilike.*$word*',
      );
    }
    final dateFrom = query.dateFrom;
    if (dateFrom != null) {
      request = request.gte('occurred_at', _startOfDay(dateFrom));
    }
    final dateTo = query.dateTo;
    if (dateTo != null) {
      request = request.lt('occurred_at', _startOfNextDay(dateTo));
    }
    if (currencyCode != null) {
      request = request.eq('currency_code', currencyCode);
    }
    if (query.channelCodes.isNotEmpty) {
      request = request.inFilter('channel_code', query.channelCodes.toList());
    }
    final labelStatus = query.labelStatus;
    if (labelStatus != null) {
      request = request.eq('is_labeled', labelStatus.dbValue);
    }
    if (query.withAiAlert) request = request.not('alert_score', 'is', null);
    return request;
  }

  static String _sortColumn(TransactionsSort sort) => switch (sort) {
    TransactionsSort.date => 'occurred_at',
    TransactionsSort.amount => 'amount',
    TransactionsSort.score => 'alert_score',
  };

  /// Characters that would change the meaning of a PostgREST filter.
  static final _unsafeSearch = RegExp(r'''[,.()*%:"'\\]''');

  static List<String> _searchWords(String search) => search
      .replaceAll(_unsafeSearch, ' ')
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList();

  /// Midnight of [day] in the analyst's time zone, as the database instant.
  static String _startOfDay(DateTime day) =>
      DateTime(day.year, day.month, day.day).toUtc().toIso8601String();

  static String _startOfNextDay(DateTime day) =>
      DateTime(day.year, day.month, day.day + 1).toUtc().toIso8601String();
}

/// The currency the country filter of [query] becomes. [known] is false when the catalog
/// does not have that country, so nothing can match.
({bool known, String? currencyCode}) currencyFilter(
  TransactionsQuery query,
  List<CatalogCountry> countries,
) {
  final countryCode = query.countryCode;
  if (countryCode == null) return (known: true, currencyCode: null);
  final currencyCode = currencyOfCountry(countryCode, countries);
  return (known: currencyCode != null, currencyCode: currencyCode);
}

/// [rows] with the labels saved in this session, which the database does not have yet.
List<TransactionRow> withLocalLabels(
  List<TransactionRow> rows,
  LocalWritesStore localWrites,
) => [
  for (final row in rows)
    switch (localWrites.labelFor(row.id)) {
      final local? => row.copyWith(
        isLabeled: true,
        verdict: local.values.verdict,
      ),
      null => row,
    },
];

/// The transactions repository of the app. With `--dart-define=USE_FAKE_DATA=true` (no
/// backend) it is [FakeTransactionsRepository].
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final localWrites = ref.watch(localWritesStoreProvider);
  return Env.useFakeData
      ? FakeTransactionsRepository(localWrites)
      : TransactionsRepository(ref.watch(supabaseClientProvider), localWrites);
}, name: 'transactionsRepositoryProvider');
