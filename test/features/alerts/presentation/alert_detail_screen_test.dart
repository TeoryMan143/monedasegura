import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alert_detail.dart';
import 'package:monedasegura/features/alerts/domain/alert_reason.dart';
import 'package:monedasegura/features/alerts/domain/alert_transaction.dart';
import 'package:monedasegura/features/alerts/presentation/alert_detail_screen.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/alerts/presentation/widgets/alert_detail_skeleton.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';

import '../../../helpers/icon_button_tooltips.dart';

class _MockRepository extends Mock implements AlertsRepository {}

class _SignedIn extends SessionController {
  @override
  Analyst? build() =>
      const Analyst(id: 'me', email: 'laura@banco.co', fullName: 'Laura Gómez');
}

const _reasons = [
  AlertReason(
    id: 'r1',
    alertId: 'a1',
    position: 1,
    weight: 0.20,
    title: 'Dispositivo nuevo',
    evidence: 'Xiaomi 12 · visto por primera vez hoy',
  ),
  AlertReason(
    id: 'r2',
    alertId: 'a1',
    position: 2,
    weight: 0.50,
    title: 'Monto 8,2× mayor al promedio de 90 días',
    evidence: r'Monto: $ 125.500 en 2 transferencias',
  ),
  AlertReason(
    id: 'r3',
    alertId: 'a1',
    position: 3,
    weight: 0.10,
    title: 'Destinatario nuevo',
    evidence: 'Sin transferencias previas del cliente',
  ),
];

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
    generatedAt: DateTime(2026, 11, 5, 9, 42),
  ),
  modelVersion: 'v1',
  reasons: const [],
  transactions: const [],
);

final _detailWithReasons = _detail.copyWith(reasons: _reasons);

const _transactions = [
  AlertTransaction(
    transactionId: 77120,
    code: 'TX-77120',
    isPrimary: true,
    amount: 84500,
    currencyCode: 'MXN',
  ),
  AlertTransaction(
    transactionId: 77121,
    code: 'TX-77121',
    isPrimary: false,
    amount: 41000,
    currencyCode: 'MXN',
  ),
];

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    // The real font, so widths in the test match the app.
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late _MockRepository repository;
  late int backs;
  late List<String> opened;

  setUp(() {
    repository = _MockRepository();
    backs = 0;
    opened = [];
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    bool canResolve = true,
    bool settle = true,
  }) async {
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          alertsRepositoryProvider.overrideWithValue(repository),
          sessionProvider.overrideWith(_SignedIn.new),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: AlertDetailScreen(
              alertId: 'a1',
              onBack: () => backs++,
              onOpenTransaction: (customerId, transactionId) =>
                  opened.add('$customerId?tx=$transactionId'),
              onOpenCustomer: (customerId, at) =>
                  opened.add('$customerId@${at.day}/${at.month}'),
              onResolve: canResolve ? () => opened.add('resolve') : null,
            ),
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  testWidgets('shows the header with breadcrumbs, title and status', (
    tester,
  ) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expect(find.text('Alerta AL-1042 · Juan Pérez'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.textContaining('Pendiente de verificación'), findsOneWidget);

    await tester.tap(find.text('Alertas IA'));
    expect(backs, 1);
  });

  testWidgets('shows the score with its range and the suggested type', (
    tester,
  ) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expect(find.text('92'), findsOneWidget);
    expect(find.text('de 100'), findsOneWidget);
    expect(find.byType(ScoreMeter), findsOneWidget);
    expect(find.textContaining('Riesgo crítico'), findsOneWidget);
    expect(find.byType(TaxonomyChip), findsOneWidget);
    expect(find.text(FraudType.accountTakeover.description), findsOneWidget);
  });

  testWidgets('lists the reasons by weight with their evidence', (
    tester,
  ) async {
    when(() => repository.getById('a1'))
        .thenAnswer((_) async => _detailWithReasons);

    await pumpScreen(tester);

    expect(find.text('3 razones · ordenadas por peso'), findsOneWidget);
    expect(find.text('Peso alto'), findsOneWidget);
    expect(find.text('Peso medio'), findsOneWidget);
    expect(find.text('Peso bajo'), findsOneWidget);
    expect(find.textContaining('Xiaomi 12'), findsOneWidget);

    // Heaviest first, even though it came second.
    final heavy = tester.getTopLeft(find.textContaining('Monto 8,2×')).dy;
    final light = tester.getTopLeft(find.text('Destinatario nuevo')).dy;
    expect(heavy, lessThan(light));
  });

  testWidgets('without reasons it says so', (tester) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expect(
      find.text('El modelo no registró razones para esta alerta.'),
      findsOneWidget,
    );
  });

  testWidgets('lists the involved transactions and opens one', (tester) async {
    when(() => repository.getById('a1'))
        .thenAnswer((_) async => _detail.copyWith(transactions: _transactions));

    await pumpScreen(tester);

    expect(find.text('Transacciones involucradas'), findsOneWidget);
    expect(find.textContaining('2 transacciones'), findsOneWidget);
    expect(find.text('Principal'), findsOneWidget);
    expect(find.text('Relacionada'), findsOneWidget);

    await tester.tap(find.text('TX-77121'));
    await tester.pump();

    expect(opened, ['c1?tx=77121']);
  });

  testWidgets('without transactions it says so', (tester) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expect(find.text('Sin transacciones'), findsOneWidget);
  });

  testWidgets('the customer card opens the customer', (tester) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expect(find.text('Cliente'), findsOneWidget);
    await tester.tap(find.text('Ver cliente'));
    await tester.pump();

    expect(opened, ['c1@5/11']);
  });

  testWidgets('a pending alert can be resolved', (tester) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expect(find.text('Esta alerta la resolvió otro analista'), findsNothing);
    expect(find.text('Resolviste esta alerta'), findsNothing);
    await tester.tap(find.text('Resolver alerta'));
    await tester.pump();
    expect(opened, ['resolve']);
  });

  testWidgets('«Resolver alerta» is disabled until the window exists', (
    tester,
  ) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester, canResolve: false);
    await tester.tap(find.text('Resolver alerta'));
    await tester.pump();

    expect(opened, isEmpty);
  });

  group('a resolved alert', () {
    AlertDetail resolvedBy({
      String? by,
      AlertStatus status = AlertStatus.confirmed,
      FraudType? type = FraudType.accountTakeover,
    }) => _detail.copyWith(
      alert: _detail.alert.copyWith(
        status: status,
        resolvedBy: by ?? 'other',
        resolvedByName: 'Diana Ortiz',
        resolvedAt: DateTime(2026, 11, 6, 18, 20),
        finalType: type,
      ),
    );

    testWidgets('by another analyst says so and disables the button', (
      tester,
    ) async {
      when(() => repository.getById('a1'))
          .thenAnswer((_) async => resolvedBy());

      await pumpScreen(tester);

      expect(
        find.text('Esta alerta la resolvió otro analista'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Diana Ortiz la confirmó como Fraude · Robo de cuenta el '
          '06 nov 2026, 18:20. Ya no se puede resolver.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Pendiente de verificación'), findsNothing);

      await tester.tap(find.text('Resolver alerta'));
      await tester.pump();
      expect(opened, isEmpty);
    });

    testWidgets('the disabled button explains why on hover', (tester) async {
      when(() => repository.getById('a1'))
          .thenAnswer((_) async => resolvedBy());
      await pumpScreen(tester);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text('Resolver alerta')));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Esta alerta ya fue resuelta'), findsOneWidget);
    });

    testWidgets('by the signed-in analyst says «Resolviste»', (tester) async {
      when(() => repository.getById('a1')).thenAnswer(
        (_) async =>
            resolvedBy(by: 'me', status: AlertStatus.rejected, type: null),
      );

      await pumpScreen(tester);

      expect(find.text('Resolviste esta alerta'), findsOneWidget);
      expect(find.text('Esta alerta la resolvió otro analista'), findsNothing);
      expect(
        find.text(
          'La rechazaste como No fraude el 06 nov 2026, 18:20. '
          'Ya no se puede resolver.',
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('every icon-only button has a tooltip', (tester) async {
    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);

    await pumpScreen(tester);

    expectIconButtonsHaveTooltips(tester);
  });

  testWidgets('an error offers to retry and recovers', (tester) async {
    when(() => repository.getById('a1')).thenThrow(const Failure.network());

    await pumpScreen(tester);
    expect(find.text('Sin conexión'), findsOneWidget);

    when(() => repository.getById('a1')).thenAnswer((_) async => _detail);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Alerta AL-1042 · Juan Pérez'), findsOneWidget);
  });

  testWidgets('while it loads it shows a skeleton shaped like the screen', (
    tester,
  ) async {
    final completer = Completer<AlertDetail>();
    when(() => repository.getById('a1')).thenAnswer((_) => completer.future);

    await pumpScreen(tester, settle: false);

    expect(find.byType(AlertDetailSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    completer.complete(_detail);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDetailSkeleton), findsNothing);
    expect(find.text('Alerta AL-1042 · Juan Pérez'), findsOneWidget);
  });

  testWidgets('an alert that does not exist says so', (tester) async {
    when(() => repository.getById('a1')).thenThrow(const Failure.notFound());

    await pumpScreen(tester);

    expect(find.text('No encontramos esta alerta'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
    await tester.tap(find.text('Volver a la bandeja'));
    expect(backs, 1);
  });
}
