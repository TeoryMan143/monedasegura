import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';

void main() {
  Map<String, dynamic> pendingRow() => {
    'id': '7f1c0a52-0000-4000-8000-000000000001',
    'code': 'AL-1042',
    'customer_id': 'c1',
    'score': 92,
    'summary': 'Monto 8,2× el promedio de 90 días',
    'status': 'pending',
    'generated_at': '2026-11-05T14:30:00+00:00',
    'resolved_by': null,
    'resolved_at': null,
    'customers': {'first_names': 'Juan', 'last_names': 'Pérez'},
    'suggested_type': {'code': 'ATO'},
    'final_type': null,
    'resolver': null,
  };

  test('reads a pending alert with its embedded tables', () {
    final alert = AiAlert.fromJson(pendingRow());

    expect(alert.code, 'AL-1042');
    expect(alert.customerName, 'Juan Pérez');
    expect(alert.score, 92);
    expect(alert.suggestedType, FraudType.accountTakeover);
    expect(alert.status, AlertStatus.pending);
    expect(alert.isResolved, isFalse);
    expect(alert.finalType, isNull);
    expect(alert.resolvedByName, isNull);
  });

  test('reads who resolved it and the final type', () {
    final alert = AiAlert.fromJson({
      ...pendingRow(),
      'status': 'reclassified',
      'resolved_by': 'a1',
      'resolved_at': '2026-11-06T09:00:00+00:00',
      'final_type': {'code': 'SIM'},
      'resolver': {'full_name': 'Laura Gómez'},
    });

    expect(alert.isResolved, isTrue);
    expect(alert.finalType, FraudType.simSwap);
    expect(alert.resolvedBy, 'a1');
    expect(alert.resolvedByName, 'Laura Gómez');
    expect(alert.resolvedAt, DateTime.utc(2026, 11, 6, 9));
  });
}
