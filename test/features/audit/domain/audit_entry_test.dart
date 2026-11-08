import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/audit_action.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart'
    as local;
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/audit/data/audit_repository.dart';
import 'package:monedasegura/features/audit/domain/audit_change.dart';
import 'package:monedasegura/features/audit/domain/audit_entry.dart';

// Rows as the seeded database returns them: TX-777 (created, then edited twice) and
// alert AL-1001 of TX-1180 (reclassified).
Map<String, dynamic> label({
  required String verdict,
  required int confidence,
  String? justification,
}) => {
  'id': '9c1d8bda-fafe-1b71-af98-590e8da38198',
  'source': 'manual',
  'verdict': verdict,
  'version': 2,
  'alert_id': null,
  'severity': null,
  'confidence': confidence,
  'justification': justification,
  'transaction_id': 777,
};

void main() {
  test('reads a row of audit_log with its analyst', () {
    final entry = AuditEntry.fromJson({
      'action': 'update_label',
      'analyst_id': 'a0000000-0000-4000-8000-000000000004',
      'old_value': label(verdict: 'uncertain', confidence: 2),
      'new_value': label(verdict: 'not_fraud', confidence: 4),
      'created_at': '2026-05-20T11:33:06.411883+00:00',
      'analyst': {'full_name': 'Juan Camilo Borrero'},
    });

    expect(entry.action, AuditAction.updateLabel);
    expect(entry.analystName, 'Juan Camilo Borrero');
    expect(entry.createdAt, DateTime.utc(2026, 5, 20, 11, 33, 6, 411, 883));
    expect(entry.isAlert, isFalse);
    expect(entry.fromSession, isFalse);
  });

  test('an edit lists only the fields that changed, with Spanish labels', () {
    final entry = AuditEntry(
      action: AuditAction.updateLabel,
      analystId: 'a4',
      analystName: 'Juan Camilo Borrero',
      createdAt: DateTime(2026, 5, 20),
      oldValue: label(
        verdict: 'uncertain',
        confidence: 2,
        justification: 'El cliente no responde.',
      ),
      newValue: label(
        verdict: 'not_fraud',
        confidence: 4,
        justification: 'Cliente reconoció la operación.',
      ),
    );

    expect(auditChanges(entry), [
      (field: 'Veredicto', before: 'Incierto', after: 'No fraude'),
      (field: 'Confianza', before: 'Media', after: 'Muy alta'),
      (
        field: 'Justificación',
        before: 'El cliente no responde.',
        after: 'Cliente reconoció la operación.',
      ),
    ]);
  });

  test('a created label lists every field it has', () {
    final entry = AuditEntry(
      action: AuditAction.createLabel,
      analystId: 'a7',
      analystName: 'Mateo Rojas',
      createdAt: DateTime(2026, 5, 14),
      newValue: label(verdict: 'not_fraud', confidence: 2),
    );

    expect(auditChanges(entry), [
      (field: 'Veredicto', before: 'Sin etiquetar', after: 'No fraude'),
      (field: 'Confianza', before: null, after: 'Media'),
    ]);
  });

  test('an alert shows its status and final type by code', () {
    final row = withFinalTypeCode(
      {
        'action': 'reclassify_alert',
        'analyst_id': 'a5',
        'old_value': {
          'code': 'AL-1001',
          'status': 'pending',
          'final_type_id': null,
        },
        'new_value': {
          'code': 'AL-1001',
          'status': 'reclassified',
          'final_type_id': 8,
        },
        'created_at': '2026-05-15T10:10:05.879673+00:00',
        'analyst': {'full_name': 'Juan Camilo Peláez'},
      },
      {8: 'CNR'},
    );
    final entry = AuditEntry.fromJson(row);

    expect(entry.isAlert, isTrue);
    expect(entry.alertCode, 'AL-1001');
    expect(auditChanges(entry), [
      (field: 'Estado', before: 'Pendiente', after: 'Reclasificada'),
      (
        field: 'Tipo final',
        before: null,
        after: FraudType.unrecognizedPurchase.label,
      ),
    ]);
  });

  test('the session changes join the database ones, newest first', () async {
    var now = DateTime(2026, 11, 7, 9);
    final store = LocalWritesStore(delay: Duration.zero, clock: () => now);
    await store.saveLabel(
      transactionId: 777,
      values: const local.LabelValues(
        verdict: Verdict.fraud,
        confidence: ConfidenceLevel.high,
        fraudTypes: [FraudType.phishing],
      ),
      analystId: 'a1',
      analystName: 'Laura Gómez',
    );
    now = DateTime(2026, 11, 7, 10);
    await store.saveLabel(
      transactionId: 777,
      values: const local.LabelValues(
        verdict: Verdict.fraud,
        confidence: ConfidenceLevel.high,
        fraudTypes: [FraudType.phishing, FraudType.simSwap],
      ),
      analystId: 'a1',
      analystName: 'Laura Gómez',
    );
    final database = AuditEntry(
      action: AuditAction.createLabel,
      analystId: 'a7',
      analystName: 'Mateo Rojas',
      createdAt: DateTime.utc(2026, 5, 14),
      newValue: label(verdict: 'not_fraud', confidence: 2),
    );

    final history = mergeAuditHistory([
      database,
    ], sessionHistory(store, 777, const {}));

    // The store does not know the label of the database, so its first save is a creation.
    expect(history.map((entry) => entry.action), [
      AuditAction.updateLabel,
      AuditAction.createLabel,
      AuditAction.createLabel,
    ]);
    expect(history.first.fromSession, isTrue);
    expect(history.last, database);
    expect(auditChanges(history.first), [
      (
        field: 'Tipos de fraude',
        before: FraudType.phishing.label,
        after: '${FraudType.phishing.label}, ${FraudType.simSwap.label}',
      ),
    ]);
  });
}
