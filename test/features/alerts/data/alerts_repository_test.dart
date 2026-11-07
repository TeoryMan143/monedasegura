import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/domain/resolve_alert_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Map<String, dynamic> _row({String id = 'a1', String status = 'pending'}) => {
  'id': id,
  'code': 'AL-1042',
  'customer_id': 'c1',
  'score': 92,
  'summary': 'Monto 8,2× el promedio de 90 días',
  'status': status,
  'generated_at': '2026-11-05T14:30:00+00:00',
  'resolved_by': null,
  'resolved_at': null,
  'customers': {'first_names': 'Juan', 'last_names': 'Pérez'},
  'suggested_type': {'code': 'ATO'},
  'final_type': null,
  'resolver': null,
};

Map<String, dynamic> _detailRow() => {
  ..._row(),
  'account_id': null,
  'model_version': 'v2.1',
  'ai_alert_reasons': [
    {
      'id': 'r1',
      'position': 1,
      'weight': 0.6,
      'title': 'A',
      'evidence': 'e1',
      'metric': null,
    },
  ],
  'ai_alert_transactions': [
    {
      'is_primary': true,
      'transactions': {
        'id': 12,
        'code': 'TX-12',
        'amount': 125500.5,
        'currency_code': 'MXN',
      },
    },
  ],
};

void main() {
  // A loopback server records what PostgREST would receive, so the tests check the real
  // query of the SDK without leaving the machine.
  late HttpServer server;
  late SupabaseClient client;
  late LocalWritesStore localWrites;
  late AlertsRepository repository;
  late Uri? request;
  late Map<String, String> requestHeaders;
  var status = HttpStatus.partialContent;
  late String body;

  setUp(() async {
    status = HttpStatus.partialContent;
    body = jsonEncode([_row()]);
    request = null;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((incoming) {
      request = incoming.uri;
      requestHeaders = {
        'prefer': incoming.headers.value('prefer') ?? '',
        'accept': incoming.headers.value('accept') ?? '',
      };
      incoming.response
        ..statusCode = status
        ..headers.contentType = ContentType.json
        ..headers.set('content-range', '0-0/37')
        ..write(body);
      incoming.response.close();
    });
    client = SupabaseClient(
      'http://127.0.0.1:${server.port}',
      'test-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    localWrites = LocalWritesStore(delay: Duration.zero);
    repository = AlertsRepository(client, localWrites);
  });

  tearDown(() async {
    await client.dispose();
    await server.close(force: true);
  });

  Map<String, String> params() => request!.queryParameters;

  List<String> allOf(String name) => request!.queryParametersAll[name] ?? [];

  Future<void> resolveInSession(String alertId, AlertStatus resolution) =>
      localWrites.resolveAlert(
        alertId: alertId,
        status: resolution,
        transactionIds: const [],
        values: const LabelValues(
          verdict: Verdict.fraud,
          confidence: ConfidenceLevel.high,
        ),
        analystId: 'an1',
        analystName: 'Laura Gómez',
      );

  group('list', () {
    test(
      'reads the pending inbox, highest score first, with its total',
      () async {
        final page = await repository.list(const AlertsQuery());

        expect(request!.path, '/rest/v1/ai_alerts');
        expect(page.total, 37);
        expect(page.items.single.code, 'AL-1042');
        expect(page.items.single.customerName, 'Juan Pérez');
        expect(requestHeaders['prefer'], contains('count=exact'));
        expect(params()['status'], 'eq.pending');
        expect(
          params()['order'],
          'score.desc.nullslast,generated_at.desc.nullslast,id.desc.nullslast',
        );
      },
    );

    test('asks the server for the page, not for the whole list', () async {
      await repository.list(const AlertsQuery(page: 3, pageSize: 50));

      expect(params()['offset'], '100');
      expect(params()['limit'], '50');
    });

    test('the score and the suggested type filter in the query', () async {
      await repository.list(
        const AlertsQuery(minScore: 80, suggestedType: FraudType.simSwap),
      );

      expect(params()['score'], 'gte.80');
      expect(params()['suggested_type.code'], 'eq.SIM');
      expect(
        params()['select'],
        contains('fraud_types!suggested_type_id!inner'),
      );
    });

    test('without a suggested type the embedded row is not required', () async {
      await repository.list(const AlertsQuery());

      expect(params()['select'], isNot(contains('!inner')));
    });

    test('a resolved status is filtered by the database', () async {
      await repository.list(const AlertsQuery(status: AlertStatus.rejected));

      expect(params()['status'], 'eq.rejected');
    });

    test('alerts resolved in the session leave the pending inbox', () async {
      await resolveInSession('a1', AlertStatus.confirmed);
      await resolveInSession('a2', AlertStatus.rejected);

      await repository.list(const AlertsQuery());

      expect(params()['status'], 'eq.pending');
      expect(params()['id'], 'not.in.(a1,a2)');
    });

    test('alerts resolved in the session join their new status', () async {
      await resolveInSession('a1', AlertStatus.confirmed);
      await resolveInSession('a2', AlertStatus.rejected);

      await repository.list(const AlertsQuery(status: AlertStatus.confirmed));

      expect(allOf('or'), ['(status.eq.confirmed,id.in.(a1))']);
      expect(params().containsKey('status'), isFalse);
    });

    test('shows the status of the session over the pending one', () async {
      await resolveInSession('a1', AlertStatus.confirmed);

      final page = await repository.list(
        const AlertsQuery(status: AlertStatus.confirmed),
      );

      final alert = page.items.single;
      expect(alert.status, AlertStatus.confirmed);
      expect(alert.resolvedByName, 'Laura Gómez');
      expect(alert.resolvedAt, isNotNull);
    });

    test('a database error becomes a Failure', () async {
      status = HttpStatus.forbidden;
      body = jsonEncode({'code': '42501', 'message': 'permission denied'});

      expect(
        repository.list(const AlertsQuery()),
        throwsA(isA<ForbiddenFailure>()),
      );
    });
  });

  group('getById', () {
    test('reads the alert with its reasons and transactions', () async {
      status = HttpStatus.ok;
      body = jsonEncode([_detailRow()]);

      final detail = await repository.getById('a1');

      expect(request!.path, '/rest/v1/ai_alerts');
      expect(params()['id'], 'eq.a1');
      expect(detail.alert.code, 'AL-1042');
      expect(detail.modelVersion, 'v2.1');
      expect(detail.reasons.single.alertId, 'a1');
      expect(detail.transactions.single.transactionId, 12);
    });

    test('throws notFound when there is no such alert', () async {
      status = HttpStatus.ok;
      body = jsonEncode([]);

      expect(repository.getById('nope'), throwsA(isA<NotFoundFailure>()));
    });

    test('shows the status of the session', () async {
      status = HttpStatus.ok;
      body = jsonEncode([_detailRow()]);
      await resolveInSession('a1', AlertStatus.rejected);

      final detail = await repository.getById('a1');

      expect(detail.alert.status, AlertStatus.rejected);
      expect(detail.alert.finalType, isNull);
      expect(detail.alert.resolvedBy, 'an1');
    });
  });

  group('resolve', () {
    // `ATO` (id 1) is what the alert suggests; `SIM` (id 7) is another type.
    const fraudTypes = [
      CatalogFraudType(
        id: 1,
        code: 'ATO',
        name: 'Robo de cuenta',
        description: '',
        colorHex: '#000000',
      ),
      CatalogFraudType(
        id: 7,
        code: 'SIM',
        name: 'SIM swap',
        description: '',
        colorHex: '#000000',
      ),
    ];

    void answerWithAlert({String alertStatus = 'pending'}) {
      status = HttpStatus.ok;
      body = jsonEncode([
        {
          'status': alertStatus,
          'suggested_type': {'code': 'ATO'},
          'ai_alert_transactions': [
            {'transaction_id': 11},
            {'transaction_id': 12},
          ],
        },
      ]);
    }

    Future<void> resolve(ResolveAlertInput input) => repository.resolve(
      input,
      fraudTypes: fraudTypes,
      analystId: 'an1',
      analystName: 'Laura Gómez',
    );

    const confirm = ResolveAlertInput(
      alertId: 'a1',
      action: ResolveAlertAction.confirm,
      severity: Severity.high,
    );

    test(
      'confirming sets the status in the store and labels the transactions',
      () async {
        answerWithAlert();

        await resolve(confirm);

        expect(localWrites.alertStatusFor('a1'), AlertStatus.confirmed);
        final resolution = localWrites.alertResolutionFor('a1')!;
        expect(resolution.finalType, FraudType.accountTakeover);
        expect(resolution.analystName, 'Laura Gómez');
        final label = localWrites.labelFor(11)!;
        expect(label.values.verdict, Verdict.fraud);
        expect(label.values.fraudTypes, [FraudType.accountTakeover]);
        expect(label.values.severity, Severity.high);
        expect(label.values.confidence, ConfidenceLevel.high);
        expect(localWrites.labelFor(12), isNotNull);
      },
    );

    test('unchecked transactions keep their label', () async {
      answerWithAlert();

      await resolve(confirm.copyWith(excludedTransactionIds: [12]));

      expect(localWrites.labelFor(11), isNotNull);
      expect(localWrites.labelFor(12), isNull);
    });

    test('rejecting labels the transactions as not fraud', () async {
      answerWithAlert();

      await resolve(
        const ResolveAlertInput(
          alertId: 'a1',
          action: ResolveAlertAction.reject,
        ),
      );

      expect(localWrites.alertStatusFor('a1'), AlertStatus.rejected);
      expect(localWrites.alertResolutionFor('a1')!.finalType, isNull);
      final label = localWrites.labelFor(11)!;
      expect(label.values.verdict, Verdict.notFraud);
      expect(label.values.fraudTypes, isEmpty);
      expect(label.values.severity, isNull);
    });

    test('reclassifying takes the type that the analyst chose', () async {
      answerWithAlert();

      await resolve(
        confirm.copyWith(action: ResolveAlertAction.reclassify, finalTypeId: 7),
      );

      expect(localWrites.alertStatusFor('a1'), AlertStatus.reclassified);
      expect(
        localWrites.alertResolutionFor('a1')!.finalType,
        FraudType.simSwap,
      );
    });

    test('throws a conflict when the database has it resolved', () async {
      answerWithAlert(alertStatus: 'confirmed');

      await expectLater(
        resolve(confirm),
        throwsA(
          isA<ConflictFailure>().having(
            (failure) => failure.key,
            'key',
            'alert_already_resolved',
          ),
        ),
      );
      expect(localWrites.alertStatusFor('a1'), isNull);
    });

    test('throws a conflict when this session already resolved it', () async {
      answerWithAlert();
      await resolve(confirm);

      await expectLater(
        resolve(confirm.copyWith(action: ResolveAlertAction.reject)),
        throwsA(isA<ConflictFailure>()),
      );
      expect(localWrites.alertStatusFor('a1'), AlertStatus.confirmed);
    });

    test('throws notFound when there is no such alert', () async {
      status = HttpStatus.ok;
      body = jsonEncode([]);

      await expectLater(resolve(confirm), throwsA(isA<NotFoundFailure>()));
    });

    Future<void> expectInvalid(ResolveAlertInput input, String key) async {
      answerWithAlert();
      await expectLater(
        resolve(input),
        throwsA(
          isA<ValidationFailure>().having((failure) => failure.key, 'key', key),
        ),
      );
      expect(localWrites.alertStatusFor(input.alertId), isNull);
    }

    test(
      'mirrors the rules of the RPC and saves nothing when they fail',
      () async {
        await expectInvalid(
          confirm.copyWith(severity: null),
          'severity_required',
        );
        await expectInvalid(
          const ResolveAlertInput(
            alertId: 'a1',
            action: ResolveAlertAction.reject,
            severity: Severity.low,
          ),
          'severity_not_allowed',
        );
        await expectInvalid(
          confirm.copyWith(action: ResolveAlertAction.reclassify),
          'fraud_type_required',
        );
        await expectInvalid(
          confirm.copyWith(
            action: ResolveAlertAction.reclassify,
            finalTypeId: 1,
          ),
          'final_type_must_differ',
        );
        await expectInvalid(
          confirm.copyWith(confidence: ConfidenceLevel.low, justification: ' '),
          'justification_required',
        );
      },
    );
  });
}
