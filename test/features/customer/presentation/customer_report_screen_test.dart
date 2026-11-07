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
import 'package:monedasegura/features/customer/data/fake_customer_report_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/presentation/customer_report_screen.dart';
import 'package:monedasegura/features/customer/presentation/customer_screen.dart';

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

  Future<void> pumpReport(WidgetTester tester, CustomerReportTab tab) async {
    tabs = [];
    backs = 0;
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

  testWidgets('Línea de tiempo and Mapa stay empty for HU-10 and HU-11', (
    tester,
  ) async {
    await pumpReport(tester, CustomerReportTab.timeline);

    expect(find.text('Esta pestaña llega con HU-10.'), findsOneWidget);
  });

  testWidgets('a tab and the breadcrumb call back', (tester) async {
    await pumpReport(tester, CustomerReportTab.summary);

    await tester.tap(find.text('Cuentas'));
    await tester.tap(find.text('Ana María Rojas').first);

    expect(tabs, [CustomerReportTab.accounts]);
    expect(backs, 1);
  });
}
