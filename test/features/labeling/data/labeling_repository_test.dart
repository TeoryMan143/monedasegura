import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/account_type.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/data/labeling_repository.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';

// Rows as the seeded database returns them (TX-69539 of AL-2272 and TX-653).
final transactionRow = <String, dynamic>{
  'id': 69539,
  'code': 'TX-69539',
  'occurred_at': '2026-10-22T20:23:00+00:00',
  'type': 'transfer',
  'channel_code': 'WEB',
  'amount': 111400000.00,
  'currency_code': 'COP',
  'merchant_name': null,
  'account_last4': '9440',
  'account_type': 'savings',
};
final labelRow = <String, dynamic>{
  'verdict': 'fraud',
  'confidence': 4,
  'severity': 'low',
  'justification': null,
  'updated_at': '2026-05-14T12:34:51.828883+00:00',
  'analysts': {'full_name': 'Jonathan Cortés'},
  'label_fraud_types': [
    {
      'fraud_types': {'code': 'CLO'},
    },
    {
      'fraud_types': {'code': 'SIM'},
    },
  ],
};
List<dynamic> alertRows(List<(String, int)> alerts) => [
  for (final (code, score) in alerts)
    {
      'ai_alerts': {
        'code': code,
        'score': score,
        'summary': '14 depósitos justo por debajo del umbral de reporte.',
        'suggested_type': {'code': 'LAV'},
      },
    },
];

void main() {
  test('reads a row of v_transactions_list', () {
    final target = targetFromRow(transactionRow);

    expect(target.code, 'TX-69539');
    expect(target.type, TransactionType.transfer);
    expect(target.channel, Channel.web);
    expect(target.amount, 111400000);
    expect(target.currency, Currency.cop);
    expect(target.accountType, AccountType.savings);
    expect(target.merchantName, isNull);
  });

  test('reads a label with its analyst and fraud types', () {
    final label = savedLabelFromRow(labelRow);

    expect(label.verdict, Verdict.fraud);
    expect(label.confidence, ConfidenceLevel.veryHigh);
    expect(label.severity, Severity.low);
    expect(label.fraudTypes, [FraudType.clonedCard, FraudType.simSwap]);
    expect(label.analystName, 'Jonathan Cortés');
  });

  test('keeps the alert with the highest score', () {
    final alert = strongestAlert(alertRows([('AL-1', 40), ('AL-2272', 78)]));

    expect(alert?.code, 'AL-2272');
    expect(alert?.suggestedType, FraudType.laundering);
    expect(strongestAlert(const []), isNull);
  });

  test(
    'a label saved in the session replaces the one of the database',
    () async {
      final store = LocalWritesStore(delay: Duration.zero);
      final target = targetFromRow(
        transactionRow,
        label: savedLabelFromRow(labelRow),
      );
      await LocalLabelWriter(store).save(
        transactionId: 69539,
        form: const LabelForm(
          verdict: Verdict.notFraud,
          confidence: ConfidenceLevel.medium,
          severity: Severity.high,
          fraudTypes: [FraudType.phishing],
        ),
        analystId: 'a1',
        analystName: 'Laura Gómez',
      );

      final merged = withPendingLabel(target, LocalLabelWriter(store));

      expect(merged.label?.verdict, Verdict.notFraud);
      expect(merged.label?.analystName, 'Laura Gómez');
      // No fraude never carries types or severity, even if the form still had them.
      expect(merged.label?.fraudTypes, isEmpty);
      expect(merged.label?.severity, isNull);
    },
  );
}
