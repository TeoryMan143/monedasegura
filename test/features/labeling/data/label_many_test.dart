import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/labeling/data/fake_labeling_repository.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _structuring = LabelForm(
  verdict: Verdict.fraud,
  fraudTypes: [FraudType.laundering],
  confidence: ConfidenceLevel.high,
  severity: Severity.critical,
);

void main() {
  group('labelMany in the prototype store', () {
    late LocalWritesStore store;
    late FakeLabelingRepository repository;

    setUp(() {
      store = LocalWritesStore(
        delay: Duration.zero,
        failingTransactionIds: const {99},
      );
      repository = FakeLabelingRepository(LocalLabelWriter(store));
    });

    Future<int> labelMany(Set<int> ids, [LabelForm form = _structuring]) =>
        repository.labelMany(
          transactionIds: ids,
          form: form,
          analystId: 'a1',
          analystName: 'Laura Gómez',
        );

    test('saves the same label on every transaction, with its audit', () async {
      await labelMany({1, 2, 3});

      for (final id in [1, 2, 3]) {
        final label = store.labelFor(id)!;
        expect(label.values.verdict, Verdict.fraud);
        expect(label.values.fraudTypes, [FraudType.laundering]);
        expect(label.values.severity, Severity.critical);
        expect(label.analystName, 'Laura Gómez');
        expect(store.auditFor(id), hasLength(1));
      }
    });

    test('returns how many already had a label', () async {
      await labelMany({1});

      expect(await labelMany({1, 2, 3}), 1);
      expect(store.labelFor(1)!.version, 2);
    });

    test('No fraude drops types and severity left in the form', () async {
      await labelMany({1}, _structuring.copyWith(verdict: Verdict.notFraud));

      final values = store.labelFor(1)!.values;
      expect(values.fraudTypes, isEmpty);
      expect(values.severity, isNull);
    });

    test('one failing transaction rejects them all', () async {
      await expectLater(labelMany({1, 99}), throwsA(isA<Failure>()));

      expect(store.labelFor(1), isNull);
    });
  });

  group('labelMany in the database', () {
    late HttpServer server;
    late SupabaseClient client;
    late List<Map<String, dynamic>> bodies;

    setUp(() async {
      bodies = [];
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        bodies.add(
          jsonDecode(await utf8.decodeStream(request)) as Map<String, dynamic>,
        );
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          // label_transactions returns how many already had a label.
          ..write('2');
        await request.response.close();
      });
      client = SupabaseClient(
        'http://127.0.0.1:${server.port}',
        'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      );
    });

    tearDown(() async {
      await client.dispose();
      await server.close(force: true);
    });

    test('calls label_transactions once with every id', () async {
      final writer = SupabaseLabelWriter(
        client,
        fraudTypes: () async => const [
          CatalogFraudType(
            id: 5,
            code: 'LAV',
            name: 'Lavado / fraccionamiento',
            description: 'Montos divididos para evadir controles.',
            colorHex: '#4CB979',
          ),
        ],
      );

      final overwritten = await writer.saveMany(
        transactionIds: {68285, 68397, 69539},
        form: _structuring,
        analystId: 'a1',
        analystName: 'Laura Gómez',
      );

      expect(overwritten, 2);
      expect(bodies.single, {
        'p_transaction_ids': [68285, 68397, 69539],
        'p_verdict': 'fraud',
        'p_confidence': 3,
        'p_fraud_type_ids': [5],
        'p_severity': 'critical',
        'p_justification': null,
      });
    });
  });
}
