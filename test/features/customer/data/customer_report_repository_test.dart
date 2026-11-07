import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/account_type.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/customer/data/customer_report_repository.dart';
import 'package:monedasegura/features/customer/domain/report_enums.dart';

// Rows as the seeded database returns them for Luciana Restrepo Torres (HU-10 demo case).
void main() {
  test('reads the customer with country and city', () {
    final profile = profileFromRow({
      'id': 'a9b76617-7834-59c4-f259-124b702b77c8',
      'first_names': 'Luciana',
      'last_names': 'Restrepo Torres',
      'document_type': 'CC',
      'document_number': '1000177113',
      'birth_date': '1992-03-15',
      'email': 'luciana.restrepo2@gmail.com',
      'phone': '+57 300 361 3426',
      'occupation': 'Conductor(a)',
      'declared_income': 1680000.00,
      'income_currency': 'COP',
      'customer_since': '2022-07-03',
      'segment': 'retail',
      'risk_level': 'medium',
      'countries': {'name': 'Colombia'},
      'cities': {'name': 'Medellín'},
    });

    expect(profile.fullName, 'Luciana Restrepo Torres');
    expect(profile.segment, CustomerSegment.retail);
    expect(profile.riskLevel, RiskLevel.medium);
    expect(profile.cityName, 'Medellín');
    expect(profile.declaredIncome, 1680000);
    expect(profile.incomeCurrency, Currency.cop);
  });

  test('reads an account with its bank', () {
    final account = accountFromRow({
      'id': 'b58ea28c-9d8a-53c2-acbf-381b39a90c0e',
      'last4': '3994',
      'type': 'savings',
      'currency_code': 'COP',
      'balance': 14186402.88,
      'credit_limit': null,
      'status': 'active',
      'opened_on': '2022-07-03',
      'banks': {'name': 'Moneda Segura Colombia'},
    });

    expect(account.type, AccountType.savings);
    expect(account.balance, 14186402.88);
    expect(account.status, ProductStatus.active);
    expect(account.bankName, 'Moneda Segura Colombia');
  });

  test('reads a card with the currency of its account', () {
    final card = cardFromRow({
      'id': '6f72e1e2-0287-a3c6-644b-ab609caa789b',
      'last4': '4916',
      'network': 'Visa',
      'type': 'debit',
      'status': 'active',
      'credit_limit': null,
      'expires_on': '2029-08-09',
      'accounts': {'last4': '3994', 'currency_code': 'COP'},
    });

    expect(card.type, CardType.debit);
    expect(card.accountLast4, '3994');
    expect(card.currency, Currency.cop);
  });

  test('reads a device of customer_devices', () {
    final device = deviceFromRow({
      'first_seen_at': '2024-05-21T12:00:00+00:00',
      'last_seen_at': '2026-10-28T04:00:00+00:00',
      'is_trusted': true,
      'devices': {
        'id': '0a1e75e4-76ec-aafa-3e8d-c193fe2d06ef',
        'os': 'iOS',
        'type': 'mobile',
        'brand': 'Apple',
        'model': 'iPhone 12',
        'os_version': '17.5',
      },
    });

    expect(device.type, DeviceType.mobile);
    expect(device.name, 'Apple iPhone 12');
    expect(device.system, 'iOS 17.5');
    expect(device.isTrusted, isTrue);
  });

  test('reads a label and an alert of the history', () {
    final label = labelItemFromRow({
      'id': 47022,
      'code': 'TX-47022',
      'occurred_at': '2026-09-03T00:58:22+00:00',
      'verdict': 'fraud',
      'labeled_by': 'a0000000-0000-4000-8000-000000000006',
      'labeled_at': '2026-09-04T10:00:00+00:00',
    }, analystName: 'Laura Gómez');
    final alert = alertItemFromRow({
      'code': 'AL-1821',
      'score': 96,
      'status': 'confirmed',
      'generated_at': '2026-09-02T23:45:00+00:00',
      'suggested_type': {'code': 'LAV'},
    });

    expect(label.verdict, Verdict.fraud);
    expect(label.analystName, 'Laura Gómez');
    expect(alert.status, AlertStatus.confirmed);
    expect(alert.suggestedType, FraudType.laundering);
  });

  test('a label saved in the session replaces the history entry', () async {
    final store = LocalWritesStore(delay: Duration.zero);
    final item = labelItemFromRow({
      'id': 47022,
      'code': 'TX-47022',
      'occurred_at': '2026-09-03T00:58:22+00:00',
      'verdict': 'fraud',
      'labeled_by': null,
      'labeled_at': null,
    });
    await store.saveLabel(
      transactionId: 47022,
      values: const LabelValues(
        verdict: Verdict.notFraud,
        confidence: ConfidenceLevel.high,
      ),
      analystId: 'a1',
      analystName: 'Juan Camilo Borrero',
    );

    final merged = withLocalHistory([item], store).single;

    expect(merged.verdict, Verdict.notFraud);
    expect(merged.analystName, 'Juan Camilo Borrero');
    expect(store.labeledTransactionIds, [47022]);
  });
}
