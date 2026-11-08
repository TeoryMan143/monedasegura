import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/catalog_providers.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/ui/save_status.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alert_detail.dart';
import 'package:monedasegura/features/alerts/domain/alert_transaction.dart';
import 'package:monedasegura/features/alerts/domain/resolve_alert_input.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/resolve_alert_controller.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';

final _detail = AlertDetail(
  alert: AiAlert(
    id: 'a1',
    code: 'AL-1042',
    customerId: 'c1',
    customerName: 'Juan Pérez',
    score: 92,
    suggestedType: FraudType.accountTakeover,
    summary: 'Resumen',
    status: AlertStatus.pending,
    generatedAt: DateTime.utc(2026, 11, 5),
  ),
  modelVersion: 'v2.1',
  reasons: const [],
  transactions: const [
    AlertTransaction(
      transactionId: 10,
      code: 'TX-10',
      isPrimary: true,
      amount: 1000,
      currencyCode: 'COP',
    ),
    AlertTransaction(
      transactionId: 11,
      code: 'TX-11',
      isPrimary: false,
      amount: 2000,
      currencyCode: 'COP',
    ),
  ],
);

const _fraudTypes = [
  CatalogFraudType(
    id: 1,
    code: 'ATO',
    name: 'Robo de cuenta',
    description: '',
    colorHex: '#000000',
  ),
  CatalogFraudType(
    id: 2,
    code: 'PHI',
    name: 'Phishing',
    description: '',
    colorHex: '#000000',
  ),
];

const _confirmForm = LabelForm(
  confidence: ConfidenceLevel.high,
  severity: Severity.medium,
);
const _rejectForm = LabelForm(
  confidence: ConfidenceLevel.high,
  justification: 'El cliente reconoce la compra.',
);
const _reclassifyForm = LabelForm(
  fraudTypes: [FraudType.phishing],
  confidence: ConfidenceLevel.high,
  severity: Severity.high,
  justification: 'Lo engañaron por teléfono.',
);

void main() {
  late List<ResolveAlertInput> sent;
  late Failure? failToThrow;
  late int detailLoads;
  const alertId = 'a1';
  final provider = resolveAlertControllerProvider(alertId);

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        alertDetailProvider(alertId).overrideWith((ref) async {
          detailLoads++;
          return _detail;
        }),
        fraudTypesProvider.overrideWith((ref) async => _fraudTypes),
        resolveAlertProvider.overrideWithValue((input) async {
          final failure = failToThrow;
          if (failure != null) throw failure;
          sent.add(input);
        }),
      ],
    );
    addTearDown(container.dispose);
    // autoDispose: the listeners keep them alive as the window would.
    container
      ..listen(provider, (_, _) {})
      ..listen(alertDetailProvider(alertId), (_, _) {});
    return container;
  }

  late ProviderContainer container;

  setUp(() {
    sent = [];
    failToThrow = null;
    detailLoads = 0;
    container = createContainer();
  });

  ResolveAlertController notifier() => container.read(provider.notifier);
  ResolveAlertState state() => container.read(provider);

  test('starts on confirm with an empty form and no errors shown', () {
    expect(state().action, ResolveAlertAction.confirm);
    expect(state().form, const LabelForm());
    expect(state().excludedTransactionIds, isEmpty);
    expect(state().visibleErrors(FraudType.accountTakeover), isEmpty);
    expect(state().saveState, SaveState.idle);
  });

  group('sending', () {
    test('confirm sends the suggested type, confidence and severity', () async {
      notifier().change(_confirmForm, LabelField.severity);

      expect(await notifier().submit(), isTrue);

      expect(
        sent.single,
        const ResolveAlertInput(
          alertId: alertId,
          action: ResolveAlertAction.confirm,
          finalTypeId: 1,
          confidence: ConfidenceLevel.high,
          severity: Severity.medium,
        ),
      );
      expect(state().saveState, SaveState.saved);
    });

    test('reject sends no type and no severity', () async {
      notifier()
        ..setAction(ResolveAlertAction.reject)
        ..change(_rejectForm, LabelField.justification);

      expect(await notifier().submit(), isTrue);

      final input = sent.single;
      expect(input.action, ResolveAlertAction.reject);
      expect(input.finalTypeId, isNull);
      expect(input.severity, isNull);
      expect(input.justification, 'El cliente reconoce la compra.');
    });

    test('reject drops the severity left from another action', () async {
      notifier()
        ..change(_confirmForm, LabelField.severity)
        ..setAction(ResolveAlertAction.reject)
        ..change(
          _confirmForm.copyWith(justification: 'No es fraude.'),
          LabelField.justification,
        );

      await notifier().submit();

      expect(sent.single.severity, isNull);
    });

    test('reclassify sends the chosen type', () async {
      notifier()
        ..setAction(ResolveAlertAction.reclassify)
        ..change(_reclassifyForm, LabelField.fraudTypes);

      expect(await notifier().submit(), isTrue);

      expect(sent.single.finalTypeId, 2);
      expect(sent.single.action, ResolveAlertAction.reclassify);
    });

    test('the unchecked transactions travel as excluded', () async {
      notifier()
        ..change(_confirmForm, LabelField.severity)
        ..toggleTransaction(11);

      await notifier().submit();

      expect(sent.single.excludedTransactionIds, [11]);
    });

    test('checking a transaction again takes it out of the excluded', () {
      notifier()
        ..toggleTransaction(11)
        ..toggleTransaction(11);

      expect(state().excludedTransactionIds, isEmpty);
    });

    test('a justification of spaces is sent as null', () async {
      notifier().change(
        _confirmForm.copyWith(justification: '   '),
        LabelField.justification,
      );

      await notifier().submit();

      expect(sent.single.justification, isNull);
    });
  });

  group('validation', () {
    test('an incomplete form is not sent and shows every error', () async {
      expect(await notifier().submit(), isFalse);

      expect(sent, isEmpty);
      expect(state().submitted, isTrue);
      expect(
        state().visibleErrors(FraudType.accountTakeover).keys,
        containsAll([LabelField.confidence, LabelField.severity]),
      );
    });

    test('before sending only the touched fields show their error', () {
      notifier().change(const LabelForm(), LabelField.severity);

      expect(state().visibleErrors(FraudType.accountTakeover).keys, [
        LabelField.severity,
      ]);
    });

    test('reclassify with the suggested type is not sent', () async {
      notifier()
        ..setAction(ResolveAlertAction.reclassify)
        ..change(
          _reclassifyForm.copyWith(fraudTypes: [FraudType.accountTakeover]),
          LabelField.fraudTypes,
        );

      expect(await notifier().submit(), isFalse);
      expect(sent, isEmpty);
    });

    test('with every transaction unchecked it is not sent', () async {
      notifier()
        ..change(_confirmForm, LabelField.severity)
        ..toggleTransaction(10)
        ..toggleTransaction(11);

      expect(await notifier().submit(), isFalse);

      expect(sent, isEmpty);
      expect(state().transactionsError(2), isNotNull);
    });
  });

  group('changing the action', () {
    test('keeps the justification and the rest of the form', () {
      notifier()
        ..change(_reclassifyForm, LabelField.justification)
        ..setAction(ResolveAlertAction.reject);

      expect(state().action, ResolveAlertAction.reject);
      expect(state().form, _reclassifyForm);
    });
  });

  group('a failed send', () {
    test(
      'a conflict keeps the form, shows the error and reloads the detail',
      () async {
        failToThrow = const Failure.conflict(key: 'alert_already_resolved');
        notifier().change(_confirmForm, LabelField.severity);

        expect(await notifier().submit(), isFalse);
        await container.read(alertDetailProvider(alertId).future);

        expect(state().saveState, SaveState.error);
        expect(state().failure, isA<ConflictFailure>());
        expect(state().form, _confirmForm);
        expect(detailLoads, 2);
      },
    );

    test(
      'another failure keeps the form and does not reload the detail',
      () async {
        failToThrow = const Failure.network();
        notifier().change(_confirmForm, LabelField.severity);

        expect(await notifier().submit(), isFalse);

        expect(state().failure, isA<NetworkFailure>());
        expect(state().form, _confirmForm);
        expect(detailLoads, 1);
      },
    );

    test('the retry clears the failure and can succeed', () async {
      failToThrow = const Failure.network();
      notifier().change(_confirmForm, LabelField.severity);
      await notifier().submit();

      failToThrow = null;
      expect(await notifier().submit(), isTrue);

      expect(state().failure, isNull);
      expect(state().saveState, SaveState.saved);
    });
  });
}
