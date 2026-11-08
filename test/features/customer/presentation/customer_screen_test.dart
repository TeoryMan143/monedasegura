import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
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

  late int backs;
  late List<CustomerReportTab> reports;

  Future<void> pumpScreen(
    WidgetTester tester, {
    String customerId = FakeCustomerRepository.customerId,
    String? transactionId,
    bool withReport = false,
  }) async {
    backs = 0;
    reports = [];
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
            body: CustomerScreen(
              customerId: customerId,
              transactionId: transactionId,
              onBack: () => backs++,
              onOpenReport: withReport ? reports.add : null,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the header shows the customer, progress and pending alerts', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.text('Ana María Rojas'), findsWidgets);
    expect(find.text('5/8 etiquetadas'), findsOneWidget);
    expect(find.text('2 alertas IA pendientes'), findsOneWidget);
    expect(
      find.textContaining('en el rango seleccionado · 8 transacciones'),
      findsOneWidget,
    );

    await tester.tap(find.text('Transacciones').first);
    expect(backs, 1);
  });

  testWidgets('the count carries the totals of the range from the database', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(
      find.text(
        r'8 transacciones · Entradas $ 5,1 M · Salidas $ 5,0 M · '
        r'Neto +$ 71.200,00 COP',
      ),
      findsOneWidget,
    );
  });

  testWidgets('rows show the customer account, counterpart and money in', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.text('EPM Servicios'), findsOneWidget);
    expect(find.text('Bil •••• 3391'), findsOneWidget);
    // The payroll credit came in.
    expect(find.text(r'+$ 4.800.000,00'), findsOneWidget);
    // A transfer to someone else went out.
    expect(find.text(r'$ 1.900.000,00'), findsNWidgets(2));
  });

  testWidgets('the account filter keeps one account and its totals', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.byType(AppDropdown<String?>));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AppMenu),
        matching: find.text('Bil •••• 3391'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Falabella.com'), findsOneWidget);
    expect(find.text('EPM Servicios'), findsNothing);
    expect(find.textContaining('1 transacción · Entradas'), findsOneWidget);
  });

  testWidgets('the checkbox selects for HU-05 without opening the panel', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.bySemanticsLabel('Seleccionar fila').first);
    await tester.pump();
    expect(find.text('1 seleccionada'), findsOneWidget);
    expect(find.text('Clasificar 1 transacción'), findsOneWidget);
    expect(find.byType(SidePanel), findsNothing);
    expect(find.text('Guardar etiqueta'), findsNothing);
  });

  testWidgets('another account clears the selection', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.bySemanticsLabel('Seleccionar fila').first);
    await tester.pump();
    expect(find.text('1 seleccionada'), findsOneWidget);

    await tester.tap(find.byType(AppDropdown<String?>));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AppMenu),
        matching: find.text('Bil •••• 3391'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 seleccionada'), findsNothing);
  });

  testWidgets('the report buttons wait for the report route', (tester) async {
    await pumpScreen(tester);

    final viewProfile = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Ver perfil'),
    );
    expect(viewProfile.onPressed, isNull);
    expect(
      find.byTooltip('Disponible cuando exista el reporte del cliente'),
      findsNWidgets(2),
    );
  });

  testWidgets('with the report route, the buttons open its tabs', (
    tester,
  ) async {
    await pumpScreen(tester, withReport: true);

    await tester.tap(find.text('Ver perfil'));
    await tester.tap(find.text('Reportes'));
    expect(reports, [CustomerReportTab.summary, CustomerReportTab.timeline]);
  });

  testWidgets('?tx= outside the range moves the range to show it', (
    tester,
  ) async {
    await pumpScreen(tester, transactionId: '48308');

    expect(find.text('Claro Colombia'), findsOneWidget);
  });

  testWidgets('an unknown customer shows an error', (tester) async {
    await pumpScreen(tester, customerId: 'missing');

    expect(find.byType(ErrorState), findsOneWidget);
  });
}
