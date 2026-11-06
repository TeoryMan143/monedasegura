import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure_mapper.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/search_result.dart';
import '../domain/search_terms.dart';

/// Global search over customers, accounts and transactions (HU-14).
///
/// Prototype: three small `ilike` queries run in parallel, at most [limitPerGroup] rows
/// each. When the `global_search` RPC is published, [search] can call it instead with the
/// same result type.
class SearchRepository {
  SearchRepository(this._client);

  final SupabaseClient _client;

  static const limitPerGroup = 5;

  Future<List<SearchResult>> search(SearchTerms terms) async {
    if (!terms.isSearchable) return const [];
    try {
      final groups = await Future.wait([
        _customers(terms),
        _accounts(terms),
        _transactions(terms),
      ]);
      return [for (final group in groups) ...group];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Name or document: every word must match a first name, last name or document.
  Future<List<SearchResult>> _customers(SearchTerms terms) async {
    var query = _client
        .from('customers')
        .select(
          'id, first_names, last_names, document_type, document_number, country_code',
        );
    for (final word in terms.words) {
      query = query.or(
        'first_names.ilike.*$word*,last_names.ilike.*$word*,'
        'document_number.ilike.*$word*',
      );
    }
    final rows = await query.order('last_names').limit(limitPerGroup);
    return [
      for (final row in rows)
        SearchResult(
          kind: SearchResultKind.customer,
          id: row['id'] as String,
          title: _fullName(row),
          subtitle:
              '${(row['document_type'] as String).toUpperCase()} '
              '${row['document_number']} · ${row['country_code']}',
          customerId: row['id'] as String,
        ),
    ];
  }

  /// Last digits of an own account (external accounts have no customer view).
  Future<List<SearchResult>> _accounts(SearchTerms terms) async {
    final digits = terms.digits;
    if (digits == null) return const [];
    final base = _client
        .from('accounts')
        .select('id, last4, type, currency_code, customer_id, '
            'customers(first_names, last_names)')
        .eq('is_external', false);
    final filtered = digits.length <= 4
        ? base.ilike('last4', '%$digits')
        : base.ilike('number', '%$digits%');
    final rows = await filtered.limit(limitPerGroup);
    return [
      for (final row in rows)
        if (row['customer_id'] != null)
          SearchResult(
            kind: SearchResultKind.account,
            id: row['id'] as String,
            title: '•••• ${row['last4']}',
            subtitle:
                '${_fullName(_map(row['customers']))} · ${row['currency_code']}',
            customerId: row['customer_id'] as String,
          ),
    ];
  }

  /// Transaction code («TX-48219»). The customer is the owner of the source account,
  /// or of the destination account for incoming transfers.
  Future<List<SearchResult>> _transactions(SearchTerms terms) async {
    final number = terms.transactionDigits;
    if (number == null) return const [];
    final rows = await _client
        .from('transactions')
        .select(
          'id, code, occurred_at, '
          'source:accounts!source_account_id(customer_id, customers(first_names, last_names)), '
          'destination:accounts!destination_account_id(customer_id, customers(first_names, last_names))',
        )
        .ilike('code', '%$number%')
        .order('occurred_at', ascending: false)
        .limit(limitPerGroup);
    final results = <SearchResult>[];
    for (final row in rows) {
      final source = _map(row['source']);
      final destination = _map(row['destination']);
      final owner = source['customer_id'] != null ? source : destination;
      final customerId = owner['customer_id'] as String?;
      if (customerId == null) continue;
      results.add(
        SearchResult(
          kind: SearchResultKind.transaction,
          id: '${row['id']}',
          title: row['code'] as String,
          subtitle: _fullName(_map(owner['customers'])),
          customerId: customerId,
          transactionId: '${row['id']}',
          occurredAt: DateTime.parse(row['occurred_at'] as String).toLocal(),
        ),
      );
    }
    return results;
  }

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : const {};

  static String _fullName(Map<String, dynamic> customer) => [
    customer['first_names'],
    customer['last_names'],
  ].whereType<String>().join(' ');
}

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(supabaseClientProvider)),
  name: 'searchRepositoryProvider',
);
