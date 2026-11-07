import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/core/catalogs/catalog_providers.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alert_detail.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/domain/resolve_alert_input.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';

class _MockRepository extends Mock implements AlertsRepository {}

class _SignedInSession extends SessionController {
  @override
  Analyst? build() => const Analyst(
    id: 'an1',
    email: 'laura@banco.co',
    fullName: 'Laura Gómez',
  );
}

class _SignedOutSession extends SessionController {
  @override
  Analyst? build() => null;
}

final _alert = AiAlert(
  id: 'a1',
  code: 'AL-1042',
  customerId: 'c1',
  customerName: 'Juan Pérez',
  score: 92,
  suggestedType: FraudType.accountTakeover,
  summary: 'Resumen',
  status: AlertStatus.pending,
  generatedAt: DateTime.utc(2026, 11, 5),
);

const _fraudTypes = [
  CatalogFraudType(
    id: 1,
    code: 'ATO',
    name: 'Robo de cuenta',
    description: '',
    colorHex: '#000000',
  ),
];

const _input = ResolveAlertInput(
  alertId: 'a1',
  action: ResolveAlertAction.reject,
);

void main() {
  late _MockRepository repository;

  setUpAll(() {
    registerFallbackValue(const AlertsQuery());
    registerFallbackValue(_input);
  });

  setUp(() {
    repository = _MockRepository();
    when(() => repository.list(any()))
        .thenAnswer((_) async => PageResult(items: [_alert], total: 1));
    when(
      () => repository.resolve(
        any(),
        fraudTypes: any(named: 'fraudTypes'),
        analystId: any(named: 'analystId'),
        analystName: any(named: 'analystName'),
      ),
    ).thenAnswer((_) async {});
  });

  ProviderContainer containerFor({bool signedIn = true}) {
    final container = ProviderContainer(
      overrides: [
        alertsRepositoryProvider.overrideWithValue(repository),
        sessionProvider.overrideWith(
          signedIn ? _SignedInSession.new : _SignedOutSession.new,
        ),
        fraudTypesProvider.overrideWith((ref) async => _fraudTypes),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('alertsPageProvider asks the repository for the query', () async {
    const query = AlertsQuery(minScore: 80, page: 2);

    final page = await containerFor().read(alertsPageProvider(query).future);

    expect(page.total, 1);
    expect(page.items.single.code, 'AL-1042');
    verify(() => repository.list(query)).called(1);
  });

  test('alertDetailProvider asks the repository for the alert', () async {
    final detail = AlertDetail(
      alert: _alert,
      modelVersion: 'v2.1',
      reasons: const [],
      transactions: const [],
    );
    when(() => repository.getById('a1')).thenAnswer((_) async => detail);

    final result = await containerFor().read(alertDetailProvider('a1').future);

    expect(result.modelVersion, 'v2.1');
  });

  test('resolving sends the analyst and reloads the inbox', () async {
    final container = containerFor();
    container.listen(alertsPageProvider(const AlertsQuery()), (_, _) {});
    await container.read(alertsPageProvider(const AlertsQuery()).future);

    await container.read(resolveAlertProvider)(_input);
    await container.read(alertsPageProvider(const AlertsQuery()).future);

    verify(
      () => repository.resolve(
        _input,
        fraudTypes: _fraudTypes,
        analystId: 'an1',
        analystName: 'Laura Gómez',
      ),
    ).called(1);
    verify(() => repository.list(any())).called(2);
  });

  test('resolving without a session fails and writes nothing', () async {
    final container = containerFor(signedIn: false);

    await expectLater(
      container.read(resolveAlertProvider)(_input),
      throwsA(isA<UnauthorizedFailure>()),
    );
    verifyNever(
      () => repository.resolve(
        any(),
        fraudTypes: any(named: 'fraudTypes'),
        analystId: any(named: 'analystId'),
        analystName: any(named: 'analystName'),
      ),
    );
  });

  test('a conflict reaches the screen and the inbox is not reloaded', () async {
    when(
      () => repository.resolve(
        any(),
        fraudTypes: any(named: 'fraudTypes'),
        analystId: any(named: 'analystId'),
        analystName: any(named: 'analystName'),
      ),
    ).thenThrow(const Failure.conflict(key: 'alert_already_resolved'));
    final container = containerFor();
    container.listen(alertsPageProvider(const AlertsQuery()), (_, _) {});
    await container.read(alertsPageProvider(const AlertsQuery()).future);

    await expectLater(
      container.read(resolveAlertProvider)(_input),
      throwsA(isA<ConflictFailure>()),
    );

    verify(() => repository.list(any())).called(1);
  });
}
