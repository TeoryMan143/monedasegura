import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/customer/data/customer_report_repository.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_report_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/domain/timeline_point.dart';
import 'package:monedasegura/features/customer/presentation/customer_report_screen.dart';
import 'package:monedasegura/features/customer/presentation/customer_screen.dart';
import 'package:monedasegura/features/customer/presentation/widgets/timeline/activity_timeline.dart';
import 'package:monedasegura/features/customer/presentation/widgets/timeline/timeline_layout.dart';

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

  late List<CustomerReportTab> tabs;
  late int backs;
  late List<int> opened;

  Future<void> pumpReport(WidgetTester tester, CustomerReportTab tab) async {
    tabs = [];
    backs = 0;
    opened = [];
    tester.view
      ..physicalSize = const Size(1280, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          customerReportRepositoryProvider.overrideWithValue(
            FakeCustomerReportRepository(LocalWritesStore()),
          ),
          customerRepositoryProvider.overrideWithValue(
            FakeCustomerRepository(LocalWritesStore()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: CustomerReportScreen(
              customerId: FakeCustomerRepository.customerId,
              tab: tab,
              onTab: tabs.add,
              onBack: () => backs++,
              onOpenList: () {},
              onOpenTransaction: opened.add,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Resumen shows the profile and the history of the range', (
    tester,
  ) async {
    await pumpReport(tester, CustomerReportTab.summary);

    expect(find.text('Ana María Rojas'), findsWidgets);
    expect(find.text('CC 1.020.456.789'), findsOneWidget);
    expect(find.text('Riesgo medio'), findsOneWidget);
    expect(find.text('Exportar PDF'), findsOneWidget);
    expect(find.text('Actividad por mes'), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.text('TX-48219'), findsOneWidget);
    expect(find.textContaining('AL-1042'), findsOneWidget);
  });

  testWidgets('Cuentas lists accounts, cards and devices', (tester) async {
    await pumpReport(tester, CustomerReportTab.accounts);

    expect(find.text('Tarjetas'), findsOneWidget);
    expect(find.textContaining('4417'), findsWidgets);
    expect(find.text('Bloqueada'), findsOneWidget);
    expect(find.textContaining('Mastercard'), findsOneWidget);
    expect(find.text('Xiaomi Redmi 12'), findsOneWidget);
    expect(find.text('Nuevo'), findsOneWidget);
  });

  testWidgets('Línea de tiempo draws the range and zooms to a day', (
    tester,
  ) async {
    await pumpReport(tester, CustomerReportTab.timeline);

    expect(find.text('Actividad en el tiempo'), findsOneWidget);
    expect(
      find.text('Selecciona un punto para ver su detalle.'),
      findsOneWidget,
    );
    expect(find.text('Evento de seguridad'), findsOneWidget);
    expect(find.text('Resaltados en el rango:'), findsOneWidget);
    for (final zoom in ['Día', 'Semana', 'Mes', 'Rango completo']) {
      expect(find.text(zoom), findsOneWidget);
    }
    expect(find.byTooltip('Anterior'), findsNothing);

    await tester.tap(find.text('Día'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Anterior'), findsOneWidget);
    expect(find.byTooltip('Siguiente'), findsOneWidget);

    await tester.tap(find.text('Semana'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rango completo'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Anterior'), findsNothing);
  });

  testWidgets('Línea de tiempo: clicking a point shows its detail', (
    tester,
  ) async {
    await pumpReport(tester, CustomerReportTab.timeline);
    final timeline = find.byType(ActivityTimeline);
    final layout = TimelineLayout(
      analysis: tester.widget<ActivityTimeline>(timeline).analysis,
      window: tester.widget<ActivityTimeline>(timeline).window,
      width: tester.getSize(timeline).width,
    );
    final mark = layout.marks.firstWhere(
      (mark) => mark.point is TransactionPoint,
    );

    await tester.tapAt(tester.getTopLeft(timeline) + mark.center);
    await tester.pumpAndSettle();

    expect(find.text('Selecciona un punto para ver su detalle.'), findsNothing);
    expect(find.text('Abrir en la vista de cliente'), findsOneWidget);
    await tester.tap(find.text('Abrir en la vista de cliente'));
    expect(opened, [(mark.point as TransactionPoint).transaction.id]);
  });

  testWidgets('Mapa explains the impossible travel and shows its detail', (
    tester,
  ) async {
    await pumpReport(tester, CustomerReportTab.map);

    // The legend names the highlighted leg.
    expect(find.text('Viaje imposible'), findsOneWidget);
    expect(
      find.textContaining(
        RegExp(r'^Viaje imposible: Medellín → Bogotá en .+ \(≈ [\d.]+ km\)$'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('TX-48219 y TX-48301'), findsOneWidget);
    expect(find.byTooltip('Encuadrar transacciones'), findsOneWidget);

    await tester.tap(find.text('Ver transacción'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrir en la vista de cliente'));

    expect(opened, [48301]);
  });

  testWidgets('a tab and the breadcrumb call back', (tester) async {
    await pumpReport(tester, CustomerReportTab.summary);

    await tester.tap(find.text('Cuentas'));
    await tester.tap(find.text('Ana María Rojas').first);

    expect(tabs, [CustomerReportTab.accounts]);
    expect(backs, 1);
  });
}
