import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/audit_action.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';

const failingId = 99;

const fraud = LabelValues(
  verdict: Verdict.fraud,
  confidence: ConfidenceLevel.high,
  severity: Severity.high,
  fraudTypes: [FraudType.phishing],
);
const notFraud = LabelValues(
  verdict: Verdict.notFraud,
  confidence: ConfidenceLevel.medium,
  justification: 'Compra habitual',
);

void main() {
  late DateTime now;
  late LocalWritesStore store;

  setUp(() {
    now = DateTime.utc(2026, 11, 6, 10);
    store = LocalWritesStore(
      failingTransactionIds: const {failingId},
      delay: Duration.zero,
      clock: () => now,
    );
  });

  Future<LocalLabel> save(
    int id,
    LabelValues values, {
    String analystId = 'a1',
  }) => store.saveLabel(
    transactionId: id,
    values: values,
    analystId: analystId,
    analystName: 'Analista $analystId',
  );

  Future<int> saveMany(Iterable<int> ids) => store.saveLabels(
    transactionIds: ids,
    values: fraud,
    analystId: 'a1',
    analystName: 'Analista a1',
  );

  Future<AlertResolution> resolve({
    String alertId = 'al1',
    AlertStatus status = AlertStatus.confirmed,
    Iterable<int> ids = const [1, 2],
    LabelValues values = fraud,
    String analystId = 'a1',
  }) => store.resolveAlert(
    alertId: alertId,
    status: status,
    transactionIds: ids,
    values: values,
    analystId: analystId,
    analystName: 'Analista $analystId',
  );

  group('saveLabel', () {
    test('a saved label reads back', () async {
      await save(1, fraud);

      final label = store.labelFor(1)!;
      expect(label.values, fraud);
      expect(label.analystName, 'Analista a1');
      expect(label.alertId, isNull);
      expect(label.version, 1);
      expect(label.createdAt, now);
    });

    test('an unknown transaction has no label', () {
      expect(store.labelFor(1), isNull);
    });

    test('an edit keeps the creation date and raises the version', () async {
      final createdAt = now;
      await save(1, fraud);
      now = now.add(const Duration(hours: 1));
      await save(1, notFraud, analystId: 'a2');

      final label = store.labelFor(1)!;
      expect(label.values, notFraud);
      expect(label.analystId, 'a2');
      expect(label.version, 2);
      expect(label.createdAt, createdAt);
      expect(label.updatedAt, now);
    });

    test('waits before saving, so the UI can show «Guardando…»', () async {
      final slow = LocalWritesStore(delay: const Duration(milliseconds: 5));

      final saving = slow.saveLabel(
        transactionId: 1,
        values: fraud,
        analystId: 'a1',
        analystName: 'Analista a1',
      );

      expect(slow.labelFor(1), isNull);
      await saving;
      expect(slow.labelFor(1), isNotNull);
    });

    test('the default delay is between 300 and 500 ms', () {
      final delay = LocalWritesStore().delay.inMilliseconds;

      expect(delay, inInclusiveRange(300, 500));
    });
  });

  group('failing transaction', () {
    test('saveLabel fails and saves nothing, also on retry', () async {
      await expectLater(save(failingId, fraud), throwsA(isA<UnknownFailure>()));
      await expectLater(save(failingId, fraud), throwsA(isA<UnknownFailure>()));

      expect(store.labelFor(failingId), isNull);
      expect(store.auditFor(failingId), isEmpty);
    });

    test('saveLabels rejects the whole batch', () async {
      await expectLater(
        saveMany([1, failingId, 2]),
        throwsA(isA<UnknownFailure>()),
      );

      expect(store.labelFor(1), isNull);
      expect(store.labelFor(2), isNull);
    });

    test('resolveAlert rejects the whole resolution', () async {
      await expectLater(
        resolve(ids: const [1, failingId]),
        throwsA(isA<UnknownFailure>()),
      );

      expect(store.alertStatusFor('al1'), isNull);
      expect(store.labelFor(1), isNull);
      expect(store.auditForAlert('al1'), isEmpty);
    });
  });

  group('saveLabels', () {
    test('labels every transaction and counts the overwritten', () async {
      await save(1, notFraud);

      final overwritten = await saveMany([1, 2, 3]);

      expect(overwritten, 1);
      expect(store.labelFor(1)!.values, fraud);
      expect(store.labelFor(2)!.values, fraud);
      expect(store.labelFor(3)!.values, fraud);
    });

    test('a repeated ID is saved once', () async {
      expect(await saveMany([1, 1]), 0);

      expect(store.labelFor(1)!.version, 1);
      expect(store.auditFor(1), hasLength(1));
    });
  });

  group('resolveAlert', () {
    test('saves the status, who resolved it and the labels', () async {
      await resolve(analystId: 'a2');

      expect(store.alertStatusFor('al1'), AlertStatus.confirmed);
      final resolution = store.alertResolutionFor('al1')!;
      expect(resolution.analystName, 'Analista a2');
      expect(resolution.resolvedAt, now);
      expect(resolution.finalType, FraudType.phishing);
      expect(store.labelFor(1)!.alertId, 'al1');
      expect(store.labelFor(2)!.values, fraud);
    });

    test('a rejected alert has no final type', () async {
      await resolve(status: AlertStatus.rejected, values: notFraud);

      expect(store.alertStatusFor('al1'), AlertStatus.rejected);
      expect(store.alertResolutionFor('al1')!.finalType, isNull);
    });

    test('only labels the transactions left checked', () async {
      await resolve(ids: const [1]);

      expect(store.labelFor(2), isNull);
    });

    test('an alert without local changes has no status', () {
      expect(store.alertStatusFor('al1'), isNull);
    });

    test('the first analyst wins', () async {
      await resolve(analystId: 'a1');

      await expectLater(
        resolve(status: AlertStatus.rejected, analystId: 'a2'),
        throwsA(
          isA<ConflictFailure>().having(
            (failure) => failure.key,
            'key',
            'alert_already_resolved',
          ),
        ),
      );

      expect(store.alertStatusFor('al1'), AlertStatus.confirmed);
      expect(store.alertResolutionFor('al1')!.analystId, 'a1');
    });

    test('a pending status is not a resolution', () async {
      await expectLater(
        resolve(status: AlertStatus.pending),
        throwsArgumentError,
      );
    });

    test('a manual edit stops pointing to the alert', () async {
      await resolve();

      await save(1, notFraud);

      expect(store.labelFor(1)!.alertId, isNull);
    });
  });

  group('audit', () {
    test('a new label records analyst, value and date', () async {
      await save(1, fraud);

      final entry = store.auditFor(1).single;
      expect(entry.action, AuditAction.createLabel);
      expect(entry.analystId, 'a1');
      expect(entry.createdAt, now);
      expect(entry.oldValue, isNull);
      expect(entry.newValue, {
        'verdict': 'fraud',
        'confidence': 3,
        'severity': 'high',
        'justification': null,
        'fraud_types': ['PHI'],
      });
    });

    test('an edit records before and after, newest first', () async {
      await save(1, fraud);
      await save(1, notFraud);

      final [edit, creation] = store.auditFor(1);
      expect(edit.action, AuditAction.updateLabel);
      expect(edit.oldValue, creation.newValue);
      expect(edit.newValue['verdict'], 'not_fraud');
    });

    test('each transaction of a batch gets its own entry', () async {
      await saveMany([1, 2]);

      expect(store.auditFor(1), hasLength(1));
      expect(store.auditFor(2), hasLength(1));
    });

    test('a resolution records the alert and each label', () async {
      await save(1, notFraud);

      await resolve(status: AlertStatus.reclassified);

      final [alert, ...labels] = store.auditForAlert('al1').reversed.toList();
      expect(alert.action, AuditAction.reclassifyAlert);
      expect(alert.transactionId, isNull);
      expect(alert.oldValue, {'status': 'pending'});
      expect(alert.newValue, {'status': 'reclassified', 'final_type': 'PHI'});
      expect(labels.map((entry) => entry.action), [
        AuditAction.updateLabel,
        AuditAction.createLabel,
      ]);
      expect(store.auditFor(1).first.alertId, 'al1');
    });

    test('entries cannot be changed from the outside', () async {
      await save(1, fraud);

      final entries = store.auditFor(1);

      expect(entries.clear, throwsUnsupportedError);
      expect(
        () => entries.single.newValue['verdict'] = 'not_fraud',
        throwsUnsupportedError,
      );
    });
  });

  group('clear', () {
    test('forgets labels, alerts and audit', () async {
      await save(3, fraud);
      await resolve();

      store.clear();

      expect(store.labelFor(1), isNull);
      expect(store.labelFor(3), isNull);
      expect(store.alertStatusFor('al1'), isNull);
      expect(store.alertResolutionFor('al1'), isNull);
      expect(store.auditFor(3), isEmpty);
      expect(store.auditForAlert('al1'), isEmpty);
    });

    test('a write still waiting does not reach the next session', () async {
      final saving = save(1, fraud);

      store.clear();

      await expectLater(saving, throwsA(isA<UnauthorizedFailure>()));
      expect(store.labelFor(1), isNull);
    });

    test('the store works again afterwards', () async {
      await save(1, fraud);
      store.clear();

      await save(1, fraud);

      expect(store.labelFor(1)!.version, 1);
    });
  });
}
