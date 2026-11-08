import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/account_type.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/domain/customer_transactions_query.dart';
import 'package:monedasegura/features/customer/domain/customer_view.dart';
import 'package:monedasegura/features/customer/domain/date_range.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _customer = CustomerView(
  id: 'c1',
  fullName: 'Ana María Rojas',
  accounts: [
    CustomerAccount(
      id: 'a1',
      last4: '4417',
      type: AccountType.savings,
      currency: Currency.cop,
    ),
    CustomerAccount(
      id: 'a2',
      last4: '8820',
      type: AccountType.checking,
      currency: Currency.cop,
    ),
  ],
  pendingAlerts: 2,
);

final _range = DateRange(from: DateTime(2026, 3), to: DateTime(2026, 3, 15));

const _row = {
  'id': 48219,
  'code': 'TX-48219',
  'occurred_at': '2026-03-03T22:41:00Z',
  'type': 'transfer',
  'channel_code': 'APP',
  'amount': 1900000,
  'currency_code': 'COP',
  'source_account_id': 'a1',
  'destination_account_id': 'x',
  'merchant_name': null,
  'alert_score': 92,
  'is_labeled': false,
  'verdict': null,
};

/// What the loopback server received.
class _Request {
  _Request(this.method, this.uri, this.body);

  final String method;
  final Uri uri;
  final String body;
}

void main() {
  // A loopback server records what PostgREST would receive, so the tests check the real
  // queries of the SDK without leaving the machine.
  late HttpServer server;
  late SupabaseClient client;
  late CustomerRepository repository;
  late List<_Request> requests;
  late Object Function(_Request request) respond;

  setUp(() async {
    requests = [];
    respond = (_) => [_row];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((incoming) async {
      final request = _Request(
        incoming.method,
        incoming.uri,
        await utf8.decodeStream(incoming),
      );
      requests.add(request);
      incoming.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..headers.set('content-range', '0-0/60')
        ..write(jsonEncode(respond(request)));
      await incoming.response.close();
    });
    client = SupabaseClient(
      'http://127.0.0.1:${server.port}',
      'test-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    repository = CustomerRepository(client, LocalWritesStore());
  });

  tearDown(() async {
    await client.dispose();
    await server.close(force: true);
  });

  final from = _range.start.toUtc().toIso8601String();
  final to = _range.end.toUtc().toIso8601String();

  test(
    'the page asks for the transactions of every account in the range',
    () async {
      final page = await repository.fetchPage(
        _customer,
        _range,
        const CustomerTransactionsQuery(page: 2, pageSize: 25),
      );

      final query = requests.single.uri.queryParametersAll;
      expect(requests.single.uri.path, '/rest/v1/v_transactions_list');
      expect(query['or'], [
        '(source_account_id.in.(a1,a2),destination_account_id.in.(a1,a2))',
      ]);
      expect(query['occurred_at'], ['gte.$from', 'lt.$to']);
      expect(query['order'], ['occurred_at.desc.nullslast,id.desc.nullslast']);
      expect(query['offset'], ['25']);
      expect(page.total, 60);
      expect(page.items.single.code, 'TX-48219');
    },
  );

  test('the account filter keeps one account', () async {
    await repository.fetchPage(
      _customer,
      _range,
      const CustomerTransactionsQuery(accountId: 'a2'),
    );

    expect(
      requests.single.uri.queryParameters['or'],
      '(source_account_id.in.(a2),destination_account_id.in.(a2))',
    );
  });

  test(
    'the totals come from the RPC with the customer and the range',
    () async {
      respond = (_) => [
        {
          'currency_code': 'COP',
          'total_in': 12400000,
          'total_out': 9800000,
          'net': 2600000,
          'transaction_count': 60,
        },
      ];

      final totals = await repository.fetchTotals(
        'c1',
        _range,
        accountId: 'a1',
      );

      expect(requests.single.method, 'POST');
      expect(requests.single.uri.path, '/rest/v1/rpc/customer_range_totals');
      expect(jsonDecode(requests.single.body), {
        'p_customer_id': 'c1',
        'p_from': from,
        'p_to': to,
        'p_account_id': 'a1',
      });
      expect(totals.single.net, 2600000);
    },
  );

  test('the progress asks only for two counts', () async {
    final progress = await repository.fetchProgress(_customer, _range);

    expect(requests.map((request) => request.method), ['HEAD', 'HEAD']);
    expect(
      requests.where(
        (request) => request.uri.queryParameters['is_labeled'] == 'eq.true',
      ),
      hasLength(1),
    );
    expect(progress.total, 60);
  });

  test('a customer without accounts asks nothing', () async {
    const empty = CustomerView(
      id: 'c2',
      fullName: 'Sin Cuentas',
      accounts: [],
      pendingAlerts: 0,
    );

    final page = await repository.fetchPage(
      empty,
      _range,
      const CustomerTransactionsQuery(),
    );
    final progress = await repository.fetchProgress(empty, _range);

    expect(requests, isEmpty);
    expect(page.total, 0);
    expect(progress.total, 0);
  });

  test(
    'the header reads the customer, the accounts and the pending alerts',
    () async {
      respond = (request) => switch (request.uri.path) {
        '/rest/v1/customers' => {
          'id': 'c1',
          'first_names': 'Ana María',
          'last_names': 'Rojas',
        },
        '/rest/v1/accounts' => [
          {
            'id': 'a1',
            'last4': '4417',
            'type': 'savings',
            'currency_code': 'COP',
          },
        ],
        _ => <Object>[],
      };

      final customer = await repository.fetchCustomer('c1');

      expect(customer.fullName, 'Ana María Rojas');
      expect(customer.accounts.single.type, AccountType.savings);
      expect(customer.pendingAlerts, 60);
      final alerts = requests.singleWhere(
        (request) => request.uri.path == '/rest/v1/ai_alerts',
      );
      expect(alerts.method, 'HEAD');
      expect(alerts.uri.queryParameters['status'], 'eq.pending');
    },
  );

  group('activity for the timeline and the map', () {
    const event = {
      'id': 'e1',
      'type': 'password_change',
      'occurred_at': '2026-03-03T22:30:00Z',
      'channel_code': 'APP',
      'succeeded': true,
      'latitude': 6.2442,
      'longitude': -75.5812,
      'city': {'name': 'Medellín'},
    };
    final older = {
      ..._row,
      'id': 48100,
      'occurred_at': '2026-03-02T10:00:00Z',
      'latitude': 6.2442,
      'longitude': -75.5812,
      'city_name': 'Medellín',
    };

    test('asks for the transactions with their place and the security events in the range', () async {
      respond = (request) => switch (request.uri.path) {
        '/rest/v1/security_events' => [event],
        _ => [
          {..._row, 'latitude': 4.711, 'longitude': -74.0721},
          older,
        ],
      };

      final activity = await repository.fetchActivity(_customer, _range);

      final transactions = requests.singleWhere(
        (request) => request.uri.path == '/rest/v1/v_transactions_list',
      );
      final query = transactions.uri.queryParametersAll;
      expect(query['select']!.single, contains('latitude'));
      expect(query['select']!.single, contains('city_name'));
      expect(query['or'], [
        '(source_account_id.in.(a1,a2),destination_account_id.in.(a1,a2))',
      ]);
      expect(query['occurred_at'], ['gte.$from', 'lt.$to']);
      expect(query['limit'], ['2001']);

      final events = requests.singleWhere(
        (request) => request.uri.path == '/rest/v1/security_events',
      );
      expect(events.uri.queryParameters['customer_id'], 'eq.c1');
      expect(events.uri.queryParameters['select'], contains('cities(name)'));
      expect(events.uri.queryParametersAll['occurred_at'], [
        'gte.$from',
        'lt.$to',
      ]);

      // The newest come first from the server; the activity is oldest first.
      expect(activity.transactions.map((row) => row.id), [48100, 48219]);
      expect(activity.transactions.last.latitude, 4.711);
      expect(activity.securityEvents.single.cityName, 'Medellín');
      expect(activity.truncated, isFalse);
    });

    test('a customer without accounts still has security events', () async {
      respond = (_) => [event];
      const empty = CustomerView(
        id: 'c2',
        fullName: 'Sin Cuentas',
        accounts: [],
        pendingAlerts: 0,
      );

      final activity = await repository.fetchActivity(empty, _range);

      expect(requests.single.uri.path, '/rest/v1/security_events');
      expect(activity.transactions, isEmpty);
      expect(activity.securityEvents, hasLength(1));
    });
  });

  test('a rejected request becomes a Failure', () async {
    await server.close(force: true);

    await expectLater(
      repository.fetchTotals('c1', _range),
      throwsA(isA<Failure>()),
    );
  });
}
