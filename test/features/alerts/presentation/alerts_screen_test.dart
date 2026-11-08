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
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/presentation/alerts_screen.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_query_controller.dart';

class _MockRepository extends Mock implements AlertsRepository {}

AiAlert _alert(String id, String customer, int score, FraudType type) =>
    AiAlert(
      id: id,
      code: 'AL-$id',
      customerId: 'c$id',
      customerName: customer,
      score: score,
      suggestedType: type,
      summary: 'Resumen de $customer',
      status: AlertStatus.pending,
      generatedAt: DateTime(2026, 11, 5, 9, 41),
    );

void main() {
  setUpAll(() async {
    registerFallbackValue(const AlertsQuery());
    await initializeDateFormatting('es');
    // The real font, so widths in the test match the app.
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late _MockRepository repository;
  late List<String> opened;

  setUp(() {
    repository = _MockRepository();
    opened = [];
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          alertsRepositoryProvider.overrideWithValue(repository),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(body: AlertsScreen(onOpen: opened.add)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the alerts in the order received, with their score', (
    tester,
  ) async {
    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [
          _alert('1', 'Juan Pérez', 92, FraudType.accountTakeover),
          _alert('2', 'Pedro Alves', 88, FraudType.moneyMule),
          _alert('3', 'María Gómez', 76, FraudType.laundering),
        ],
        total: 3,
      ),
    );

    await pumpScreen(tester);

    expect(find.text('Bandeja de alertas IA'), findsOneWidget);
    expect(find.text('92'), findsOneWidget);
    expect(find.text('88'), findsOneWidget);
    expect(find.text('76'), findsOneWidget);
    expect(find.byType(TaxonomyChip), findsNWidgets(3));
    expect(find.textContaining('ATO'), findsOneWidget);
    expect(find.text('AL-1'), findsOneWidget);

    final top = [
      for (final name in ['Juan Pérez', 'Pedro Alves', 'María Gómez'])
        tester.getTopLeft(find.text(name)).dy,
    ];
    expect(top, [...top]..sort());
  });

  testWidgets('shows the empty state when there are no pending alerts', (
    tester,
  ) async {
    when(() => repository.list(any()))
        .thenAnswer((_) async => const PageResult(items: [], total: 0));

    await pumpScreen(tester);

    expect(find.text('No hay alertas pendientes'), findsOneWidget);
  });

  testWidgets('shows the error and retries when the network fails', (
    tester,
  ) async {
    when(() => repository.list(any())).thenThrow(const Failure.network());

    await pumpScreen(tester);

    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [_alert('1', 'Juan Pérez', 92, FraudType.accountTakeover)],
        total: 1,
      ),
    );
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Juan Pérez'), findsOneWidget);
  });

  testWidgets('the bar counts the alerts and shows a chip per active filter', (
    tester,
  ) async {
    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [
          _alert('1', 'Juan Pérez', 92, FraudType.accountTakeover),
          _alert('2', 'Pedro Alves', 88, FraudType.moneyMule),
        ],
        total: 2,
      ),
    );

    await pumpScreen(tester);
    expect(find.text('2 alertas pendientes'), findsOneWidget);
    expect(find.text('Limpiar filtros'), findsNothing);

    final notifier = ProviderScope.containerOf(
      tester.element(find.byType(AlertsScreen)),
    ).read(alertsQueryProvider.notifier);
    notifier
      ..setMinScore(80)
      ..setStatus(AlertStatus.confirmed);
    await tester.pumpAndSettle();

    expect(find.textContaining('≥ 80'), findsOneWidget);
    expect(find.textContaining('Confirmada'), findsOneWidget);
    expect(find.text('2 alertas'), findsOneWidget);

    await tester.tap(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();

    expect(find.textContaining('≥ 80'), findsNothing);
    expect(find.text('2 alertas pendientes'), findsOneWidget);
  });

  testWidgets('the panel changes nothing until «Aplicar filtros»', (
    tester,
  ) async {
    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [_alert('1', 'Juan Pérez', 92, FraudType.accountTakeover)],
        total: 1,
      ),
    );
    await pumpScreen(tester);

    await tester.tap(find.widgetWithText(AppButton, 'Filtros'));
    await tester.pumpAndSettle();
    expect(find.byType(SidePanel), findsOneWidget);

    await tester.tap(find.text('Cualquiera'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Alto o más'));
    await tester.pumpAndSettle();

    // Still the default query behind the panel.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AlertsScreen)),
    );
    expect(container.read(alertsQueryProvider).minScore, isNull);

    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.byType(SidePanel), findsNothing);
    expect(container.read(alertsQueryProvider).minScore, 70);
    expect(find.textContaining('≥ 70'), findsOneWidget);
    verify(() => repository.list(any(that: isA<AlertsQuery>())))
        .called(greaterThan(1));
  });

  testWidgets('paginates on the server: next page asks for page 2', (
    tester,
  ) async {
    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [_alert('1', 'Juan Pérez', 92, FraudType.accountTakeover)],
        total: 60,
      ),
    );
    await pumpScreen(tester);
    expect(find.text('Mostrando 1–25 de 60 alertas'), findsOneWidget);

    await tester.tap(find.byTooltip('Página siguiente'));
    await tester.pumpAndSettle();

    expect(find.text('Mostrando 26–50 de 60 alertas'), findsOneWidget);
    final queries = verify(() => repository.list(captureAny())).captured;
    expect((queries.last as AlertsQuery).page, 2);
  });

  testWidgets('with filters and no results it offers to clear them', (
    tester,
  ) async {
    when(() => repository.list(any()))
        .thenAnswer((_) async => const PageResult(items: [], total: 0));
    await pumpScreen(tester);

    ProviderScope.containerOf(tester.element(find.byType(AlertsScreen)))
        .read(alertsQueryProvider.notifier)
        .setMinScore(85);
    await tester.pumpAndSettle();

    expect(find.text('Sin resultados'), findsOneWidget);
    expect(find.text('No hay alertas pendientes'), findsNothing);
    await tester.tap(find.widgetWithText(AppButton, 'Limpiar filtros').last);
    await tester.pumpAndSettle();
    expect(find.text('No hay alertas pendientes'), findsOneWidget);
  });

  testWidgets('a click on a row opens that alert', (tester) async {
    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [
          _alert('1', 'Juan Pérez', 92, FraudType.accountTakeover),
          _alert('2', 'Pedro Alves', 88, FraudType.moneyMule),
        ],
        total: 2,
      ),
    );
    await pumpScreen(tester);

    await tester.tap(find.text('Pedro Alves'));
    await tester.pump();

    expect(opened, ['2']);
  });
}
