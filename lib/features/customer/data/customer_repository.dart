import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/domain/alert_status.dart';
import '../../../core/domain/page_result.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_provider.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/customer_transaction.dart';
import '../domain/customer_transactions_query.dart';
import '../domain/customer_view.dart';
import '../domain/date_range.dart';
import '../domain/range_totals.dart';
import 'fake_customer_repository.dart';

/// Reads the A-02 customer view (HU-03): the customer, their accounts and pending
/// alerts, the labeling progress and the totals of the range, and the transactions of
/// all their accounts. Filters, sort, pagination and sums run in the database.
///
/// A transaction belongs to the customer when one of their accounts is its source or its
/// destination, so a transfer between two customers shows in both views.
class CustomerRepository {
  CustomerRepository(this._client, this._localWrites);

  final SupabaseClient _client;
  final LocalWritesStore _localWrites;

  static const _view = 'v_transactions_list';
  static const _columns =
      'id, code, occurred_at, type, channel_code, amount, currency_code, '
      'source_account_id, destination_account_id, merchant_name, alert_score, '
      'is_labeled, verdict';

  Future<CustomerView> fetchCustomer(String customerId) async {
    try {
      final results = await Future.wait<Object>([
        _client
            .from('customers')
            .select('id, first_names, last_names')
            .eq('id', customerId)
            .single(),
        _client
            .from('accounts')
            .select('id, last4, type, currency_code')
            .eq('customer_id', customerId)
            .order('type')
            .order('last4'),
        _client
            .from('ai_alerts')
            .count(CountOption.exact)
            .eq('customer_id', customerId)
            .eq('status', AlertStatus.pending.dbValue),
      ]);
      final customer = results[0] as Map<String, dynamic>;
      final accounts = results[1] as List<Map<String, dynamic>>;
      return CustomerView(
        id: customerId,
        fullName: '${customer['first_names']} ${customer['last_names']}',
        accounts: [for (final row in accounts) CustomerAccount.fromJson(row)],
        pendingAlerts: results[2] as int,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// When [transactionId] happened, so the view can show it (`?tx=`). Null if it does
  /// not exist.
  Future<DateTime?> fetchTransactionDate(int transactionId) async {
    try {
      final row = await _client
          .from(_view)
          .select('occurred_at')
          .eq('id', transactionId)
          .maybeSingle();
      final occurredAt = row?['occurred_at'] as String?;
      return occurredAt == null ? null : DateTime.parse(occurredAt);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Labeled and total transactions of the customer in [range]. Two counts, no rows.
  Future<LabelProgress> fetchProgress(
    CustomerView customer,
    DateRange range, {
    String? accountId,
  }) async {
    if (customer.accounts.isEmpty) {
      return const LabelProgress(labeled: 0, total: 0);
    }
    try {
      PostgrestFilterBuilder<int> count() => _applyFilters(
        _client.from(_view).count(CountOption.exact),
        customer.accountIds,
        range,
        accountId,
      );
      final counts = await Future.wait([
        count().eq('is_labeled', true),
        count(),
      ]);
      return LabelProgress(labeled: counts[0], total: counts[1]);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Money in, money out and net per currency in [range], from the
  /// `customer_range_totals` RPC.
  Future<List<RangeTotals>> fetchTotals(
    String customerId,
    DateRange range, {
    String? accountId,
  }) async {
    try {
      final rows = await _client.rpc<List<dynamic>>(
        'customer_range_totals',
        params: {
          'p_customer_id': customerId,
          'p_from': range.start.toUtc().toIso8601String(),
          'p_to': range.end.toUtc().toIso8601String(),
          'p_account_id': accountId,
        },
      );
      return [
        for (final row in rows)
          RangeTotals.fromJson(row as Map<String, dynamic>),
      ];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  Future<PageResult<CustomerTransaction>> fetchPage(
    CustomerView customer,
    DateRange range,
    CustomerTransactionsQuery query,
  ) async {
    if (customer.accounts.isEmpty) return const PageResult(items: [], total: 0);
    try {
      final response =
          await _applyFilters(
                _client.from(_view).select(_columns),
                customer.accountIds,
                range,
                query.accountId,
              )
              .order(switch (query.sort) {
                CustomerTransactionsSort.date => 'occurred_at',
                CustomerTransactionsSort.amount => 'amount',
              }, ascending: query.ascending)
              // Rows with the same value keep their order from one page to the next.
              .order('id', ascending: false)
              .range(query.from, query.to)
              .count(CountOption.exact);
      return PageResult(
        items: withLocalLabels([
          for (final row in response.data) CustomerTransaction.fromJson(row),
        ], _localWrites),
        total: response.count,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// The transactions of [accountIds] (or only [accountId]) in [range].
  PostgrestFilterBuilder<T> _applyFilters<T>(
    PostgrestFilterBuilder<T> request,
    Set<String> accountIds,
    DateRange range,
    String? accountId,
  ) {
    final accounts = accountId ?? accountIds.join(',');
    return request
        .or(
          'source_account_id.in.($accounts),'
          'destination_account_id.in.($accounts)',
        )
        .gte('occurred_at', range.start.toUtc().toIso8601String())
        .lt('occurred_at', range.end.toUtc().toIso8601String());
  }
}

/// [rows] with the labels saved in this session, which the database does not have yet.
List<CustomerTransaction> withLocalLabels(
  List<CustomerTransaction> rows,
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

/// The customer repository of the app. With `--dart-define=USE_FAKE_DATA=true` (no
/// backend) it is [FakeCustomerRepository].
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final localWrites = ref.watch(localWritesStoreProvider);
  return Env.useFakeData
      ? FakeCustomerRepository(localWrites)
      : CustomerRepository(ref.watch(supabaseClientProvider), localWrites);
}, name: 'customerRepositoryProvider');
