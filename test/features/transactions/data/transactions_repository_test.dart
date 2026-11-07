import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/country.dart';
import 'package:monedasegura/core/domain/label_status.dart';
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';
import 'package:monedasegura/features/transactions/domain/transaction_row.dart';
import 'package:monedasegura/features/transactions/domain/transactions_query.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _row = {
  'id': 48219,
  'code': 'TX-48219',
  'occurred_at': '2026-03-19T22:41:00Z',
  'customer_id': '00000000-0000-4000-8000-000000000001',
  'customer_name': 'Ana María Rojas',
  'account_last4': '4417',
  'source_account_id': '00000000-0000-4000-9000-000000000001',
  'destination_account_id': '00000000-0000-4000-9000-000000000101',
  'type': 'transfer',
  'channel_code': 'PSE',
  'amount': 1900000,
  'currency_code': 'COP',
  'alert_score': 92,
  'is_labeled': false,
  'verdict': null,
};

void main() {
  // A loopback server records what PostgREST would receive, so the tests check the real
  // query of the SDK without leaving the machine.
  late HttpServer server;
  late SupabaseClient client;
  late LocalWritesStore localWrites;
  late TransactionsRepository repository;
  late List<CatalogCountry> countries;
  late Uri? request;
  late Map<String, String> requestHeaders;
  var status = HttpStatus.partialContent;
  var body = jsonEncode([_row]);

  setUp(() async {
    status = HttpStatus.partialContent;
    body = jsonEncode([_row]);
    request = null;
    countries = await FakeCatalogRepository().fetchCountries();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((incoming) {
      request = incoming.uri;
      requestHeaders = {
        'prefer': incoming.headers.value('prefer') ?? '',
        'range': incoming.headers.value('range') ?? '',
      };
      incoming.response
        ..statusCode = status
        ..headers.contentType = ContentType.json
        ..headers.set('content-range', '0-0/50312')
        ..write(body);
      incoming.response.close();
    });
    client = SupabaseClient(
      'http://127.0.0.1:${server.port}',
      'test-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    localWrites = LocalWritesStore();
    repository = TransactionsRepository(client, localWrites);
  });

  tearDown(() async {
    await client.dispose();
    await server.close(force: true);
  });

  Map<String, String> params() => request!.queryParameters;

  List<String> allOf(String name) => request!.queryParametersAll[name] ?? [];

  Future<PageResult<TransactionRow>> fetch(TransactionsQuery query) =>
      repository.fetchPage(query, countries: countries);

  test('reads the first page and its exact total from the view', () async {
    final page = await fetch(const TransactionsQuery());

    expect(request!.path, '/rest/v1/v_transactions_list');
    expect(page.total, 50312);
    expect(page.items.single.code, 'TX-48219');
    expect(page.items.single.country, Country.colombia);
    expect(requestHeaders['prefer'], contains('count=exact'));
    expect(params()['offset'], '0');
    expect(params()['limit'], '25');
  });

  test('asks the server for the page, not for the whole list', () async {
    await fetch(const TransactionsQuery(page: 3, pageSize: 50));

    expect(params()['offset'], '100');
    expect(params()['limit'], '50');
  });

  test('sorts on the server, newest first, with a stable tie-break', () async {
    await fetch(const TransactionsQuery());

    expect(params()['order'], 'occurred_at.desc.nullslast,id.desc.nullslast');
  });

  test('every sort uses its column and direction', () async {
    await fetch(
      const TransactionsQuery(sort: TransactionsSort.amount, ascending: true),
    );
    expect(params()['order'], 'amount.asc.nullslast,id.desc.nullslast');

    await fetch(const TransactionsQuery(sort: TransactionsSort.score));
    expect(params()['order'], 'alert_score.desc.nullslast,id.desc.nullslast');
  });

  test('every filter goes in the query', () async {
    await fetch(
      const TransactionsQuery(
        countryCode: 'CO',
        channelCode: 'PSE',
        labelStatus: LabelStatus.unlabeled,
        withAiAlert: true,
      ),
    );

    expect(params()['channel_code'], 'eq.PSE');
    expect(params()['is_labeled'], 'eq.false');
    expect(params()['alert_score'], 'not.is.null');
  });

  test('the country filters by its currency, read from the catalog', () async {
    await fetch(const TransactionsQuery(countryCode: 'CO'));

    expect(params()['currency_code'], 'eq.COP');
  });

  test(
    'a country outside the catalog asks nothing and finds nothing',
    () async {
      final page = await fetch(const TransactionsQuery(countryCode: 'US'));

      expect(request, isNull);
      expect(page.items, isEmpty);
      expect(page.total, 0);
    },
  );

  test(
    'a currency outside the catalog leaves the row without country',
    () async {
      countries = const [];

      final page = await fetch(const TransactionsQuery());

      expect(page.items.single.country, isNull);
    },
  );

  test('without filters the query has none', () async {
    await fetch(const TransactionsQuery());

    expect(
      params().keys,
      unorderedEquals(['select', 'order', 'offset', 'limit']),
    );
  });

  test('the date range includes both days in the local time zone', () async {
    await fetch(
      TransactionsQuery(
        dateFrom: DateTime(2026, 3, 1, 15),
        dateTo: DateTime(2026, 3, 31, 15),
      ),
    );

    expect(allOf('occurred_at'), [
      'gte.${DateTime(2026, 3).toUtc().toIso8601String()}',
      'lt.${DateTime(2026, 4).toUtc().toIso8601String()}',
    ]);
  });

  test('the search looks in customer, account digits and ID', () async {
    await fetch(const TransactionsQuery(search: 'rojas'));

    expect(
      params()['or'],
      '(customer_name.ilike.*rojas*,account_last4.ilike.*rojas*,'
      'code.ilike.*rojas*)',
    );
  });

  test('every word of the search must match', () async {
    await fetch(const TransactionsQuery(search: 'ana 4417'));

    expect(allOf('or'), hasLength(2));
    expect(allOf('or').last, contains('account_last4.ilike.*4417*'));
  });

  test('the search cannot change the filter', () async {
    await fetch(const TransactionsQuery(search: 'a,b.c(d)*%:"'));

    expect(allOf('or'), hasLength(4));
    for (final filter in allOf('or')) {
      expect(filter, isNot(contains(',b')));
      expect(filter, isNot(contains('(d')));
    }
  });

  test('a blank search sends no filter', () async {
    await fetch(const TransactionsQuery(search: '  ,  '));

    expect(params(), isNot(contains('or')));
  });

  test('the row carries the customer and the account digits', () async {
    final page = await fetch(const TransactionsQuery());

    expect(page.items.single.customerName, 'Ana María Rojas');
    expect(page.items.single.accountLast4, '4417');
  });

  test('a label saved in this session replaces the one of the view', () async {
    await localWrites.saveLabel(
      transactionId: 48219,
      values: const LabelValues(
        verdict: Verdict.notFraud,
        confidence: ConfidenceLevel.high,
      ),
      analystId: 'analyst-1',
      analystName: 'Analista',
    );

    final page = await fetch(const TransactionsQuery());

    expect(page.items.single.labelStatus, LabelStatus.labeled);
    expect(page.items.single.verdict, Verdict.notFraud);
  });

  test('a rejected request becomes a Failure', () async {
    status = HttpStatus.unauthorized;
    body = jsonEncode({
      'code': '42501',
      'message': 'permission denied for view v_transactions_list',
    });

    await expectLater(
      fetch(const TransactionsQuery()),
      throwsA(isA<ForbiddenFailure>()),
    );
  });

  test('a row out of contract becomes a Failure', () async {
    body = jsonEncode([
      {..._row, 'type': 'barter'},
    ]);

    await expectLater(
      fetch(const TransactionsQuery()),
      throwsA(isA<UnknownFailure>()),
    );
  });
}
