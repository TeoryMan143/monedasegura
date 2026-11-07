import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/audit_action.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/country.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/domain_enum.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/theme/status_tone.dart';

void main() {
  group('every value has a label and survives the database round trip', () {
    void check<T extends DomainEnum>(
      String name,
      List<T> values,
      T Function(T value) roundTrip,
    ) {
      test(name, () {
        for (final value in values) {
          expect(value.label.trim(), isNotEmpty);
          expect(roundTrip(value), value);
        }
        expect(
          values.map((value) => value.dbValue).toSet(),
          hasLength(values.length),
          reason: 'database values must be unique',
        );
      });
    }

    check(
      'AuditAction',
      AuditAction.values,
      (v) => AuditAction.fromDb(v.dbValue),
    );
    check('Verdict', Verdict.values, (v) => Verdict.fromDb(v.dbValue));
    check('Severity', Severity.values, (v) => Severity.fromDb(v.dbValue));
    check(
      'ConfidenceLevel',
      ConfidenceLevel.values,
      (v) => ConfidenceLevel.fromDb(v.dbValue),
    );
    check(
      'AlertStatus',
      AlertStatus.values,
      (v) => AlertStatus.fromDb(v.dbValue),
    );
    check('FraudType', FraudType.values, (v) => FraudType.fromDb(v.dbValue));
    check('Channel', Channel.values, (v) => Channel.fromDb(v.dbValue));
    check('Currency', Currency.values, (v) => Currency.fromDb(v.dbValue));
    check('Country', Country.values, (v) => Country.fromDb(v.dbValue));
  });

  test('database values match docs/mer.puml', () {
    List<Object> db(List<DomainEnum> values) => [
      for (final value in values) value.dbValue,
    ];

    expect(db(Verdict.values), ['fraud', 'not_fraud', 'uncertain']);
    expect(db(Severity.values), ['low', 'medium', 'high', 'critical']);
    expect(db(ConfidenceLevel.values), [1, 2, 3, 4]);
    expect(db(AlertStatus.values), [
      'pending',
      'confirmed',
      'rejected',
      'reclassified',
    ]);
    expect(db(FraudType.values), [
      'ATO',
      'PHI',
      'CLO',
      'MUL',
      'LAV',
      'SIN',
      'SIM',
      'CNR',
    ]);
    expect(db(Channel.values), [
      'APP',
      'WEB',
      'POS',
      'ATM',
      'PSE',
      'SPEI',
      'YAPE',
      'PIX',
      'INTERBANK',
      'PAYROLL',
    ]);
    expect(db(Currency.values), ['COP', 'MXN', 'PEN', 'CLP', 'ARS', 'BRL']);
    expect(db(Country.values), ['CO', 'MX', 'PE', 'CL', 'AR', 'BR']);
  });

  test('an unknown database value throws', () {
    expect(() => Verdict.fromDb('maybe'), throwsArgumentError);
    expect(() => ConfidenceLevel.fromDb(5), throwsArgumentError);
    expect(() => FraudType.fromDb('ato'), throwsArgumentError);
  });

  test('labels and tones follow AGENTS.md and DESIGN.md', () {
    expect(Verdict.fraud.label, 'Fraude');
    expect(Verdict.fraud.tone, StatusTone.danger);
    expect(Verdict.notFraud.tone, StatusTone.success);
    expect(Verdict.uncertain.tone, StatusTone.warning);

    expect(Severity.values.map((s) => s.tone), [
      StatusTone.neutral,
      StatusTone.warning,
      StatusTone.high,
      StatusTone.danger,
    ]);
    expect(AlertStatus.values.map((s) => s.tone), [
      StatusTone.warning,
      StatusTone.danger,
      StatusTone.success,
      StatusTone.info,
    ]);
  });

  test('every severity and confidence level has its criteria text', () {
    for (final severity in Severity.values) {
      expect(severity.description, isNotEmpty);
    }
    for (final level in ConfidenceLevel.values) {
      expect(level.criteria, isNotEmpty);
    }
  });

  test('only low confidence requires a justification', () {
    expect(
      ConfidenceLevel.values.where((level) => level.requiresJustification),
      [ConfidenceLevel.low],
    );
  });

  test('only pending alerts are unresolved', () {
    expect(AlertStatus.pending.isResolved, isFalse);
    expect(AlertStatus.confirmed.isResolved, isTrue);
    expect(AlertStatus.rejected.isResolved, isTrue);
    expect(AlertStatus.reclassified.isResolved, isTrue);
  });

  test('each resolved status has its audit action', () {
    expect(
      AuditAction.forResolution(AlertStatus.confirmed),
      AuditAction.confirmAlert,
    );
    expect(
      AuditAction.forResolution(AlertStatus.rejected),
      AuditAction.rejectAlert,
    );
    expect(
      AuditAction.forResolution(AlertStatus.reclassified),
      AuditAction.reclassifyAlert,
    );
  });

  test('CLP has no decimals and every country has its currency', () {
    expect(Currency.clp.decimals, 0);
    expect(Country.chile.currency, Currency.clp);
    expect(Country.brazil.currency, Currency.brl);
  });
}
