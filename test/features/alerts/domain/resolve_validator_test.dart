import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/features/alerts/domain/resolve_alert_input.dart';
import 'package:monedasegura/features/alerts/domain/resolve_validator.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';

const suggested = FraudType.accountTakeover;

const confirmForm = LabelForm(
  confidence: ConfidenceLevel.high,
  severity: Severity.medium,
);
const rejectForm = LabelForm(
  confidence: ConfidenceLevel.high,
  justification: 'El cliente reconoce la compra.',
);
const reclassifyForm = LabelForm(
  fraudTypes: [FraudType.phishing],
  confidence: ConfidenceLevel.high,
  severity: Severity.high,
  justification: 'El cliente fue engañado por una llamada.',
);

Map<LabelField, String> validate(ResolveAlertAction action, LabelForm form) =>
    validateResolution(action: action, form: form, suggested: suggested);

void main() {
  group('resolutionLabel', () {
    test('confirm is fraud with the suggested type', () {
      final label = resolutionLabel(
        action: ResolveAlertAction.confirm,
        form: confirmForm,
        suggested: suggested,
      );
      expect(label.verdict, Verdict.fraud);
      expect(label.fraudTypes, [suggested]);
    });

    test('reject is not fraud and drops the types and the severity', () {
      final label = resolutionLabel(
        action: ResolveAlertAction.reject,
        form: reclassifyForm,
        suggested: suggested,
      );
      expect(label.verdict, Verdict.notFraud);
      expect(label.fraudTypes, isEmpty);
      expect(label.severity, isNull);
    });

    test('reclassify is fraud with the chosen type', () {
      final label = resolutionLabel(
        action: ResolveAlertAction.reclassify,
        form: reclassifyForm,
        suggested: suggested,
      );
      expect(label.verdict, Verdict.fraud);
      expect(label.fraudTypes, [FraudType.phishing]);
    });
  });

  group('validateResolution · confirm', () {
    test('is valid with confidence and severity', () {
      expect(validate(ResolveAlertAction.confirm, confirmForm), isEmpty);
    });

    test('needs a severity', () {
      final errors = validate(
        ResolveAlertAction.confirm,
        confirmForm.copyWith(severity: null),
      );
      expect(errors.keys, [LabelField.severity]);
    });

    test('needs a confidence', () {
      final errors = validate(
        ResolveAlertAction.confirm,
        confirmForm.copyWith(confidence: null),
      );
      expect(errors.keys, [LabelField.confidence]);
    });

    test('needs a justification when the confidence is low', () {
      final errors = validate(
        ResolveAlertAction.confirm,
        confirmForm.copyWith(confidence: ConfidenceLevel.low),
      );
      expect(errors.keys, [LabelField.justification]);
    });

    test('does not need a justification otherwise', () {
      expect(validate(ResolveAlertAction.confirm, confirmForm), isEmpty);
    });

    test('ignores a type left over from reclassifying', () {
      final form = confirmForm.copyWith(fraudTypes: [FraudType.simSwap]);
      expect(validate(ResolveAlertAction.confirm, form), isEmpty);
    });
  });

  group('validateResolution · reject', () {
    test('is valid with a justification and a confidence', () {
      expect(validate(ResolveAlertAction.reject, rejectForm), isEmpty);
    });

    test('needs a justification', () {
      final errors = validate(
        ResolveAlertAction.reject,
        rejectForm.copyWith(justification: '   '),
      );
      expect(errors, {
        LabelField.justification: 'Explica por qué rechazas la alerta.',
      });
    });

    test('needs a confidence', () {
      final errors = validate(
        ResolveAlertAction.reject,
        rejectForm.copyWith(confidence: null),
      );
      expect(errors.keys, [LabelField.confidence]);
    });

    test('ignores the severity and the types left from other actions', () {
      final form = rejectForm.copyWith(
        severity: Severity.critical,
        fraudTypes: [FraudType.phishing],
      );
      expect(validate(ResolveAlertAction.reject, form), isEmpty);
    });
  });

  group('validateResolution · reclassify', () {
    test(
      'is valid with another type, confidence, severity and justification',
      () {
        expect(
          validate(ResolveAlertAction.reclassify, reclassifyForm),
          isEmpty,
        );
      },
    );

    test('needs a type', () {
      final errors = validate(
        ResolveAlertAction.reclassify,
        reclassifyForm.copyWith(fraudTypes: const []),
      );
      expect(errors.keys, [LabelField.fraudTypes]);
    });

    test('needs a type different from the suggested one', () {
      final errors = validate(
        ResolveAlertAction.reclassify,
        reclassifyForm.copyWith(fraudTypes: [suggested]),
      );
      expect(errors, {LabelField.fraudTypes: 'Elige un tipo distinto de ATO.'});
    });

    test('accepts only one type', () {
      final errors = validate(
        ResolveAlertAction.reclassify,
        reclassifyForm.copyWith(
          fraudTypes: [FraudType.phishing, FraudType.simSwap],
        ),
      );
      expect(errors.keys, [LabelField.fraudTypes]);
    });

    test('needs a severity', () {
      final errors = validate(
        ResolveAlertAction.reclassify,
        reclassifyForm.copyWith(severity: null),
      );
      expect(errors.keys, [LabelField.severity]);
    });

    test('needs a justification even with high confidence', () {
      final errors = validate(
        ResolveAlertAction.reclassify,
        reclassifyForm.copyWith(justification: ''),
      );
      expect(errors, {LabelField.justification: 'Explica la reclasificación.'});
    });
  });

  group('validateTransactionSelection', () {
    test('fails when none is marked', () {
      expect(validateTransactionSelection(0), isNotNull);
    });

    test('passes with one or more marked', () {
      expect(validateTransactionSelection(1), isNull);
      expect(validateTransactionSelection(3), isNull);
    });
  });

  group('resolutionSummary', () {
    String? summary({
      ResolveAlertAction action = ResolveAlertAction.confirm,
      LabelForm form = confirmForm,
      required int selected,
      int labeled = 0,
    }) => resolutionSummary(
      action: action,
      form: form,
      suggested: suggested,
      selectedCount: selected,
      alreadyLabeledCount: labeled,
    );

    test('is null when none is marked', () {
      expect(summary(selected: 0), isNull);
    });

    test('uses the singular for one transaction', () {
      expect(
        summary(selected: 1),
        'Se etiquetará 1 transacción como Fraude · Robo de cuenta.',
      );
    });

    test('uses the plural for several transactions', () {
      expect(
        summary(selected: 2),
        'Se etiquetarán 2 transacciones como Fraude · Robo de cuenta.',
      );
    });

    test('says how many will be replaced, in the singular', () {
      expect(
        summary(selected: 2, labeled: 1),
        'Se etiquetarán 2 transacciones como Fraude · Robo de cuenta. '
        '1 ya tenía etiqueta y se reemplazará.',
      );
    });

    test('says how many will be replaced, in the plural', () {
      expect(
        summary(selected: 3, labeled: 2),
        'Se etiquetarán 3 transacciones como Fraude · Robo de cuenta. '
        '2 ya tenían etiqueta y se reemplazarán.',
      );
    });

    test('rejecting labels as not fraud, without a type', () {
      expect(
        summary(
          action: ResolveAlertAction.reject,
          form: rejectForm,
          selected: 2,
        ),
        'Se etiquetarán 2 transacciones como No fraude.',
      );
    });

    test('reclassifying shows the chosen type', () {
      expect(
        summary(
          action: ResolveAlertAction.reclassify,
          form: reclassifyForm,
          selected: 1,
        ),
        'Se etiquetará 1 transacción como Fraude · Phishing / ingeniería social.',
      );
    });

    test('reclassifying without a type yet shows only the verdict', () {
      expect(
        summary(
          action: ResolveAlertAction.reclassify,
          form: const LabelForm(),
          selected: 1,
        ),
        'Se etiquetará 1 transacción como Fraude.',
      );
    });
  });
}
