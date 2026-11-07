import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';
import 'package:monedasegura/features/labeling/domain/label_validator.dart';

const validFraud = LabelForm(
  verdict: Verdict.fraud,
  fraudTypes: [FraudType.phishing],
  confidence: ConfidenceLevel.high,
  severity: Severity.high,
);
const validNotFraud = LabelForm(
  verdict: Verdict.notFraud,
  confidence: ConfidenceLevel.medium,
);
const validUncertain = LabelForm(
  verdict: Verdict.uncertain,
  confidence: ConfidenceLevel.medium,
  justification: 'El cliente no responde y no hay reclamo.',
);

void main() {
  group('valid labels', () {
    test('fraud with a type, a severity and high confidence', () {
      expect(validateLabel(validFraud), isEmpty);
    });

    test('fraud with several types', () {
      final form = validFraud.copyWith(
        fraudTypes: [FraudType.accountTakeover, FraudType.simSwap],
      );
      expect(validateLabel(form), isEmpty);
    });

    test('not fraud without types, severity or justification', () {
      expect(validateLabel(validNotFraud), isEmpty);
    });

    test('uncertain with a justification', () {
      expect(validateLabel(validUncertain), isEmpty);
    });

    test('low confidence with a justification', () {
      final form = validFraud.copyWith(
        confidence: ConfidenceLevel.low,
        justification: 'Un solo indicio: dispositivo nuevo.',
      );
      expect(validateLabel(form), isEmpty);
    });

    test('a justification of exactly 500 characters', () {
      final form = validUncertain.copyWith(justification: 'a' * 500);
      expect(validateLabel(form), isEmpty);
    });
  });

  group('required fields', () {
    test('an empty form asks for a verdict and a confidence level', () {
      expect(validateLabel(const LabelForm()), {
        LabelField.verdict: 'Elige un veredicto.',
        LabelField.confidence: 'Elige un nivel de confianza.',
      });
    });
  });

  group('fraud', () {
    test('needs at least one fraud type', () {
      final form = validFraud.copyWith(fraudTypes: []);
      expect(validateLabel(form), {
        LabelField.fraudTypes: 'Elige al menos un tipo de fraude.',
      });
    });

    test('needs a severity', () {
      final form = validFraud.copyWith(severity: null);
      expect(validateLabel(form), {
        LabelField.severity: 'Elige una severidad.',
      });
    });
  });

  group('not fraud', () {
    test('takes no fraud types', () {
      final form = validNotFraud.copyWith(fraudTypes: [FraudType.phishing]);
      expect(validateLabel(form), {
        LabelField.fraudTypes:
            'Una etiqueta de no fraude no lleva tipos de fraude.',
      });
    });

    test('takes no severity', () {
      final form = validNotFraud.copyWith(severity: Severity.low);
      expect(validateLabel(form), {
        LabelField.severity: 'Una etiqueta de no fraude no lleva severidad.',
      });
    });
  });

  group('justification', () {
    test('is required with confidence 1 (Baja)', () {
      final form = validFraud.copyWith(confidence: ConfidenceLevel.low);
      expect(validateLabel(form), {
        LabelField.justification: 'Explica por qué la confianza es baja.',
      });
    });

    test('is required with an uncertain verdict', () {
      final form = validUncertain.copyWith(justification: '');
      expect(validateLabel(form), {
        LabelField.justification: 'Explica por qué el veredicto es incierto.',
      });
    });

    test('only spaces count as empty', () {
      final form = validUncertain.copyWith(justification: '   \n ');
      expect(validateLabel(form).keys, [LabelField.justification]);
    });

    test('is at most 500 characters', () {
      final form = validUncertain.copyWith(justification: 'a' * 501);
      expect(validateLabel(form), {
        LabelField.justification:
            'La justificación admite máximo 500 caracteres.',
      });
    });

    test('the limit is also checked when it is optional', () {
      final form = validNotFraud.copyWith(justification: 'a' * 501);
      expect(validateLabel(form).keys, [LabelField.justification]);
    });

    test('counts accented letters and emoji as one character each', () {
      final form = validUncertain.copyWith(justification: 'é' * 499 + '🙂');
      expect(validateLabel(form), isEmpty);
    });
  });

  test('reports every broken rule at once', () {
    const form = LabelForm(
      verdict: Verdict.fraud,
      confidence: ConfidenceLevel.low,
    );
    expect(validateLabel(form).keys, {
      LabelField.fraudTypes,
      LabelField.severity,
      LabelField.justification,
    });
  });
}
