import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/app/router.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/formatting/money.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/statistics/data/statistics_repository.dart';
import 'package:monedasegura/features/statistics/domain/ai_performance.dart';
import 'package:monedasegura/features/statistics/domain/confusion_matrix.dart';
import 'package:monedasegura/features/statistics/domain/fraud_kpis.dart';
import 'package:monedasegura/features/statistics/domain/grouped_count.dart';
import 'package:monedasegura/features/statistics/domain/statistics_filter.dart';
import 'package:monedasegura/features/statistics/domain/stats_group_by.dart';
import 'package:monedasegura/features/statistics/domain/time_series_point.dart';
import 'package:monedasegura/features/statistics/domain/type_precision.dart';
import 'package:monedasegura/features/statistics/presentation/controllers/statistics_providers.dart';
import 'package:monedasegura/features/statistics/presentation/statistics_screen.dart';

import '../../../helpers/icon_button_tooltips.dart';

class _MockRepository extends Mock implements StatisticsRepository {}

void main() {
  setUpAll(() async {
    registerFallbackValue(const StatisticsFilter());
    registerFallbackValue(StatsGroupBy.type);
    await initializeDateFormatting('es');
    // The real font, so widths in the test match the app.
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late _MockRepository repository;
  late ProviderContainer container;

  const kpis = FraudKpis(
    labeledCount: 38420,
    totalCount: 50312,
    fraudCount: 1084,
    committedAmountCop: 1284000000,
  );

  setUp(() {
    repository = _MockRepository();
    when(() => repository.fraudKpis(any())).thenAnswer((_) async => kpis);
    when(() => repository.fraudOverTime(any())).thenAnswer(
      (_) async => [
        TimeSeriesPoint(periodStart: DateTime(2026, 3, 2), fraudCount: 12),
        TimeSeriesPoint(periodStart: DateTime(2026, 3, 16), fraudCount: 7),
      ],
    );
    when(() => repository.fraudGrouped(any(), any())).thenAnswer(
      (_) async => const [
        GroupedCount(key: 'PHI', count: 118),
        GroupedCount(key: 'ATO', count: 298),
        GroupedCount(key: 'CLO', count: 176),
      ],
    );
  });

  Future<GoRouter> pumpScreen(WidgetTester tester, {bool settle = true}) async {
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container = ProviderContainer(
      overrides: [
        statisticsRepositoryProvider.overrideWithValue(repository),
        catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
      ],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: AppRoutes.statisticsTab(StatisticsTab.fraud),
      routes: [
        GoRoute(
          path: '${AppRoutes.statistics}/:tab',
          builder: (context, state) => Scaffold(
            body: StatisticsScreen(
              tab: StatisticsTab.fromPath(state.pathParameters['tab']),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
    return router;
  }

  testWidgets('the three cards show the values formatted', (tester) async {
    await pumpScreen(tester);

    expect(find.text('76 %'), findsOneWidget);
    expect(
      find.text('38.420 de 50.312 transacciones etiquetadas'),
      findsOneWidget,
    );
    expect(find.text('1.084'), findsOneWidget);
    expect(find.text(formatMoney(1284000000, Currency.cop)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing the country asks the repository for that country', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.text('País: Todos los países', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Colombia'));
    await tester.pumpAndSettle();

    verify(
      () => repository.fraudKpis(const StatisticsFilter(countryCode: 'CO')),
    ).called(1);
    verify(
      () => repository.fraudGrouped(
        const StatisticsFilter(countryCode: 'CO'),
        StatsGroupBy.type,
      ),
    ).called(1);
  });

  testWidgets('the filter survives switching tabs', (tester) async {
    final router = await pumpScreen(tester);
    container.read(statisticsFilterProvider.notifier).setCountry('MX');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Desempeño de la IA'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.statisticsTab(StatisticsTab.ai));
    expect(container.read(statisticsFilterProvider).countryCode, 'MX');
    expect(find.text('País: México', findRichText: true), findsOneWidget);
  });

  testWidgets('«Agrupar por» asks only for the bars and sorts them', (
    tester,
  ) async {
    await pumpScreen(tester);
    clearInteractions(repository);
    when(() => repository.fraudGrouped(any(), StatsGroupBy.channel)).thenAnswer(
      (_) async => const [
        GroupedCount(key: 'WEB', count: 10),
        GroupedCount(key: 'APP', count: 40),
      ],
    );

    await tester.tap(find.text('Canal'));
    await tester.pumpAndSettle();

    verify(
      () => repository.fraudGrouped(
        const StatisticsFilter(),
        StatsGroupBy.channel,
      ),
    ).called(1);
    verifyNever(() => repository.fraudKpis(any()));
    verifyNever(() => repository.fraudOverTime(any()));
    // Highest first: the app channel above web banking.
    expect(
      tester.getTopLeft(find.text('App móvil')).dy,
      lessThan(tester.getTopLeft(find.text('Banca web')).dy),
    );
  });

  testWidgets('the bars by type come highest first', (tester) async {
    await pumpScreen(tester);

    final order = [
      for (final label in [
        'Robo de cuenta',
        'Tarjeta clonada',
        'Phishing / ingeniería social',
      ])
        tester.getTopLeft(find.text(label)).dy,
    ];
    expect(order, [...order]..sort());
  });

  testWidgets('while loading every card and panel shows its own skeleton', (
    tester,
  ) async {
    final kpisDone = Completer<FraudKpis>();
    final seriesDone = Completer<List<TimeSeriesPoint>>();
    final groupedDone = Completer<List<GroupedCount>>();
    when(() => repository.fraudKpis(any())).thenAnswer((_) => kpisDone.future);
    when(() => repository.fraudOverTime(any()))
        .thenAnswer((_) => seriesDone.future);
    when(() => repository.fraudGrouped(any(), any()))
        .thenAnswer((_) => groupedDone.future);

    await pumpScreen(tester, settle: false);

    expect(find.bySemanticsLabel('Cargando'), findsWidgets);
    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // One panel answers while the others still load: it does not wait for them.
    kpisDone.complete(kpis);
    await tester.pump();
    await tester.pump();
    expect(find.text('1.084'), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);

    seriesDone.complete(const []);
    groupedDone.complete(const []);
    await tester.pumpAndSettle();
  });

  testWidgets('A-07 has no icon-only button without a tooltip', (tester) async {
    await pumpScreen(tester);

    expectIconButtonsHaveTooltips(tester);
  });

  testWidgets('a failing panel shows «Reintentar» and leaves the others', (
    tester,
  ) async {
    when(() => repository.fraudOverTime(any()))
        .thenAnswer((_) async => throw const Failure.network());
    await pumpScreen(tester);

    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text('1.084'), findsOneWidget);
    expect(find.text('Robo de cuenta'), findsOneWidget);

    when(() => repository.fraudOverTime(any())).thenAnswer(
      (_) async => [
        TimeSeriesPoint(periodStart: DateTime(2026, 3, 2), fraudCount: 12),
      ],
    );
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('without frauds the chart shows the empty state', (tester) async {
    when(() => repository.fraudOverTime(any())).thenAnswer((_) async => []);
    await pumpScreen(tester);

    expect(find.text('Sin datos en este rango'), findsOneWidget);
  });

  group('the «Desempeño de la IA» tab', () {
    Future<void> openAiTab(WidgetTester tester) async {
      final router = await pumpScreen(tester);
      router.go(AppRoutes.statisticsTab(StatisticsTab.ai));
      await tester.pumpAndSettle();
    }

    testWidgets('the three cards add up to 100 % and the bars are sorted', (
      tester,
    ) async {
      when(() => repository.aiPerformance(any())).thenAnswer(
        (_) async => const AiPerformance(
          confirmed: 930,
          rejected: 375,
          reclassified: 195,
          precisionByType: [
            TypePrecision(typeCode: 'PHI', precision: 0.56, alerts: 40),
            TypePrecision(typeCode: 'ATO', precision: 0.7, alerts: 120),
          ],
        ),
      );
      await openAiTab(tester);

      for (final text in ['62 %', '25 %', '13 %']) {
        expect(find.text(text), findsOneWidget);
      }
      expect(find.text('930 alertas · tipo correcto'), findsOneWidget);
      expect(find.text('Confirmadas'), findsOneWidget);
      // Highest precision first, then the types with no resolved alerts.
      expect(find.text('70 %'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Robo de cuenta')).dy,
        lessThan(
          tester.getTopLeft(find.text('Phishing / ingeniería social')).dy,
        ),
      );
      expect(find.text('Sin datos'), findsNWidgets(6));
      expect(tester.takeException(), isNull);
    });

    testWidgets('with no resolved alerts the cards read «—»', (tester) async {
      when(() => repository.aiPerformance(any())).thenAnswer(
        (_) async =>
            const AiPerformance(confirmed: 0, rejected: 0, reclassified: 0),
      );
      await openAiTab(tester);

      expect(find.text('—'), findsNWidgets(3));
      expect(find.text('0 %'), findsNothing);
      expect(find.text('Sin datos en este rango'), findsOneWidget);
    });

    testWidgets('A-08 has no icon-only button without a tooltip', (
      tester,
    ) async {
      await openAiTab(tester);

      expectIconButtonsHaveTooltips(tester);
    });

    testWidgets('an error shows «Reintentar» in the cards and the panel', (
      tester,
    ) async {
      when(() => repository.aiPerformance(any()))
          .thenAnswer((_) async => throw const Failure.network());
      await openAiTab(tester);

      expect(find.text('Reintentar'), findsNWidgets(2));
    });
  });

  group('the confusion matrix dialog', () {
    const matrix = ConfusionMatrix(
      rows: ['ATO', 'PHI'],
      columns: ['ATO', 'PHI', ConfusionMatrix.noFraudKey],
      cells: [
        [3, 1, 0],
        [2, 5, 4],
      ],
    );

    Future<void> openMatrix(WidgetTester tester) async {
      when(() => repository.aiPerformance(any())).thenAnswer(
        (_) async => const AiPerformance(
          confirmed: 8,
          rejected: 4,
          reclassified: 3,
          precisionByType: [],
        ),
      );
      when(() => repository.confusionMatrix(any()))
          .thenAnswer((_) async => matrix);
      final router = await pumpScreen(tester);
      router.go(AppRoutes.statisticsTab(StatisticsTab.ai));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ver matriz de confusión'));
      await tester.pumpAndSettle();
    }

    testWidgets('every cell prints its number, zero included', (tester) async {
      await openMatrix(tester);

      expect(find.text('Matriz de confusión'), findsOneWidget);
      expect(find.text('Todo el periodo · Todos los países'), findsOneWidget);
      const expected = {
        'cell-0-0': '3',
        'cell-0-1': '1',
        'cell-0-2': '0',
        'cell-1-0': '2',
        'cell-1-1': '5',
        'cell-1-2': '4',
      };
      for (final entry in expected.entries) {
        expect(
          find.descendant(
            of: find.byKey(ValueKey(entry.key)),
            matching: find.text(entry.value),
          ),
          findsOneWidget,
          reason: entry.key,
        );
      }
      expect(find.textContaining('15 alertas resueltas'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('only the diagonal carries the hit mark, with a text legend', (
      tester,
    ) async {
      await openMatrix(tester);

      bool hasCheck(String key) => find
          .descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(AppIcon),
          )
          .evaluate()
          .isNotEmpty;
      expect(hasCheck('cell-0-0'), isTrue);
      expect(hasCheck('cell-1-1'), isTrue);
      expect(hasCheck('cell-0-1'), isFalse);
      expect(hasCheck('cell-1-2'), isFalse);
      expect(
        find.text('Acierto: el tipo final coincide con el sugerido'),
        findsOneWidget,
      );
    });

    testWidgets('each cell describes itself to a screen reader', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await openMatrix(tester);

      expect(
        find.bySemanticsLabel('Sugerida PHI, final ATO: 2 alertas'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Sugerida ATO, final PHI: 1 alerta'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Sugerida PHI, final No fraude: 4 alertas'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('Esc closes it, and so does «Cerrar»', (tester) async {
      await openMatrix(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Matriz de confusión'), findsNothing);

      await tester.tap(find.text('Ver matriz de confusión'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();
      expect(find.text('Matriz de confusión'), findsNothing);
    });

    testWidgets('N-04 has its × with a tooltip', (tester) async {
      await openMatrix(tester);

      expect(expectIconButtonsHaveTooltips(tester), greaterThanOrEqualTo(1));
    });

    testWidgets('opens with the focus on «Cerrar» and Enter closes it', (
      tester,
    ) async {
      await openMatrix(tester);

      final focused = FocusManager.instance.primaryFocus?.context;
      expect(
        focused?.findAncestorWidgetOfExactType<AppButton>()?.label,
        'Cerrar',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Matriz de confusión'), findsNothing);
    });

    testWidgets('a failure shows «Reintentar» inside the dialog', (
      tester,
    ) async {
      await openMatrix(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      when(() => repository.confusionMatrix(any()))
          .thenAnswer((_) async => throw const Failure.network());

      await tester.tap(find.text('Ver matriz de confusión'));
      await tester.pumpAndSettle();

      expect(find.text('Reintentar'), findsOneWidget);
    });
  });
}
