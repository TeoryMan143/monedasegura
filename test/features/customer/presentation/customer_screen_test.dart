import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/presentation/customer_screen.dart';
import 'package:monedasegura/features/labeling/data/fake_labeling_repository.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/data/labeling_repository.dart';
import 'package:monedasegura/features/labeling/presentation/bulk_label_dialog.dart';

/// Width of the side menu of the test shell.
const _menuWidth = 200.0;

class _SignedIn extends SessionController {
  @override
  Analyst? build() => const Analyst(
    id: 'a1',
    email: 'laura.gomez@monedasegura.test',
    fullName: 'Laura Gómez',
  );
}

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
  late GoRouter router;

  /// A-02 behind a real router, which keeps the open transaction in `?tx=` as the app's
  /// does. The customer view and the panel share one store, as in the prototype.
  Future<void> pumpScreen(
    WidgetTester tester, {
    String customerId = FakeCustomerRepository.customerId,
    String? transactionId,
    String? at,
    bool withReport = false,
    bool withMenu = false,
  }) async {
    backs = 0;
    reports = [];
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final store = LocalWritesStore(delay: Duration.zero);
    final query = [
      if (transactionId != null) 'tx=$transactionId',
      if (at != null) 'at=$at',
    ];
    final routes = [
      GoRoute(
        path: '/customers/:customerId',
        builder: (context, state) {
          final id = state.pathParameters['customerId']!;
          return Scaffold(
            body: CustomerScreen(
              customerId: id,
              transactionId: state.uri.queryParameters['tx'],
              at: state.uri.queryParameters['at'],
              onSelectTransaction: (tx) => context.replace(
                tx == null ? '/customers/$id' : '/customers/$id?tx=$tx',
              ),
              onBack: () => backs++,
              onOpenReport: withReport ? reports.add : null,
            ),
          );
        },
      ),
      // A page pushed over A-02, like the customer report.
      GoRoute(
        path: '/other',
        builder: (context, state) =>
            const Scaffold(body: Text('Otra pantalla')),
      ),
    ];
    router = GoRouter(
      initialLocation: query.isEmpty
          ? '/customers/$customerId'
          : '/customers/$customerId?${query.join('&')}',
      routes: withMenu
          // Like the app's shell: a side menu left of the pages' own navigator.
          ? [
              ShellRoute(
                builder: (context, state, child) => Row(
                  children: [
                    const SizedBox(
                      width: _menuWidth,
                      child: Material(child: Center(child: Text('Menú'))),
                    ),
                    Expanded(child: child),
                  ],
                ),
                routes: routes,
              ),
            ]
          : routes,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          customerRepositoryProvider.overrideWithValue(
            FakeCustomerRepository(store),
          ),
          labelingRepositoryProvider.overrideWithValue(
            FakeLabelingRepository(LocalLabelWriter(store)),
          ),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
          sessionProvider.overrideWith(_SignedIn.new),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The `?tx=` of the current location, or null without it.
  String? openTransaction() =>
      router.routeInformationProvider.value.uri.queryParameters['tx'];

  Finder inPanel(Finder finder) =>
      find.descendant(of: find.byType(SidePanel), matching: finder);

  Future<void> tapInPanel(WidgetTester tester, String text) async {
    final target = inPanel(find.text(text)).first;
    await tester.ensureVisible(target);
    await tester.tap(target);
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

  testWidgets('A-03 from A-02 labels the rows and moves the progress', (
    tester,
  ) async {
    await pumpScreen(tester);
    // 48301 (unlabeled) and 48219 (fraud): one new label, one replaced.
    final boxes = find.bySemanticsLabel('Seleccionar fila');
    await tester.tap(boxes.at(0));
    await tester.pump();
    await tester.tap(boxes.at(1));
    await tester.pump();
    await tester.tap(find.text('Clasificar 2 transacciones'));
    await tester.pumpAndSettle();

    Finder inDialog(String text) => find
        .descendant(of: find.byType(BulkLabelDialog), matching: find.text(text))
        .first;
    await tester.tap(inDialog('No fraude'));
    await tester.pumpAndSettle();
    await tester.tap(inDialog('Alta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar a 2 transacciones'));
    await tester.pumpAndSettle();
    expect(find.text('1 etiqueta nueva'), findsOneWidget);
    await tester.tap(find.text('Aplicar a 2 transacciones').last);
    await tester.pumpAndSettle();

    expect(find.byType(BulkLabelDialog), findsNothing);
    expect(find.text('6/8 etiquetadas'), findsOneWidget);
    expect(find.text('Quitar selección'), findsNothing);
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

  testWidgets('a click on a row opens N-02 on it and writes ?tx=', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.byType(SidePanel), findsNothing);

    await tester.tap(find.text('Éxito Laureles'));
    await tester.pumpAndSettle();

    expect(openTransaction(), '48303');
    expect(inPanel(find.text('TX-48303')), findsOneWidget);
  });

  testWidgets('?tx= opens the panel; Siguiente moves it and ?tx= follows', (
    tester,
  ) async {
    await pumpScreen(tester, transactionId: '48302');
    expect(inPanel(find.text('TX-48302')), findsOneWidget);

    await tapInPanel(tester, 'Siguiente');

    expect(openTransaction(), '48303');
    expect(inPanel(find.text('TX-48303')), findsOneWidget);
    expect(find.text('TX-48302'), findsNothing);
  });

  testWidgets('closing the panel removes ?tx=', (tester) async {
    await pumpScreen(tester, transactionId: '48302');

    await tester.tap(find.byTooltip('Cerrar panel'));
    await tester.pumpAndSettle();

    expect(openTransaction(), isNull);
    expect(find.byType(SidePanel), findsNothing);
  });

  testWidgets('the open panel dims the whole window, side menu included', (
    tester,
  ) async {
    await pumpScreen(tester, transactionId: '48302', withMenu: true);

    final dim = find.byWidgetPredicate(
      (widget) => widget is ColoredBox && widget.color == AppColors.bgOverlay,
    );
    expect(tester.getRect(dim), Offset.zero & const Size(1280, 720));

    // A click on the dimmed menu closes the panel, as on the rest of the dimmed area.
    await tester.tapAt(const Offset(_menuWidth / 2, 360));
    await tester.pumpAndSettle();

    expect(openTransaction(), isNull);
    expect(find.byType(SidePanel), findsNothing);
    expect(dim, findsNothing);
  });

  testWidgets(
    'on a short window N-02 shrinks to fit: no scroll, nothing under the actions',
    (tester) async {
      await pumpScreen(tester, transactionId: '48302');
      final next = inPanel(find.text('Siguiente'));
      final lastLine = inPanel(
        find.text('Obligatoria con confianza Baja o veredicto Incierto.'),
      );
      final amount = inPanel(find.textContaining('182.400'));

      // With Fraude the form gets its types and severity, the tallest it gets.
      await tester.tap(inPanel(find.text('Fraude')));
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(1280, 500);
      await tester.pumpAndSettle();

      expect(inPanel(find.byType(SingleChildScrollView)), findsNothing);
      // Everything shows: the top of the summary, the end of the form, the actions.
      expect(tester.getTopLeft(amount).dy, greaterThan(0));
      expect(
        tester.getBottomLeft(lastLine).dy,
        lessThan(tester.getTopLeft(next).dy),
      );
      expect(tester.getBottomLeft(next).dy, lessThanOrEqualTo(500));
      // The form still takes taps once scaled down.
      await tester.tap(inPanel(find.text('Media')).first);
      await tester.pumpAndSettle();
      expect(inPanel(find.textContaining('Dos o más indicios')), findsWidgets);
    },
  );

  testWidgets('a page pushed over A-02 hides the panel until it comes back', (
    tester,
  ) async {
    await pumpScreen(tester, transactionId: '48302', withMenu: true);

    unawaited(router.push('/other'));
    await tester.pumpAndSettle();
    expect(find.text('Otra pantalla'), findsOneWidget);
    expect(find.byType(SidePanel), findsNothing);

    router.pop();
    await tester.pumpAndSettle();
    expect(inPanel(find.text('TX-48302')), findsOneWidget);
  });

  testWidgets('a save changes the badge of the row and the progress', (
    tester,
  ) async {
    // TX-48301 is the row of 22:47.
    Finder badgeOfRow() => find.descendant(
      of: find.ancestor(of: find.text('22:47'), matching: find.byType(Row)),
      matching: find.byType(StatusBadge),
    );
    await pumpScreen(tester, transactionId: '48301');
    expect(find.text('5/8 etiquetadas'), findsOneWidget);
    expect(
      tester.widget<StatusBadge>(badgeOfRow().first).label,
      'Sin etiquetar',
    );

    await tapInPanel(tester, 'No fraude');
    await tapInPanel(tester, 'Alta');
    await tapInPanel(tester, 'Guardar etiqueta');

    expect(find.text('Etiqueta guardada'), findsOneWidget);
    expect(find.text('6/8 etiquetadas'), findsOneWidget);
    expect(tester.widget<StatusBadge>(badgeOfRow().first).label, 'No fraude');
    // The panel stays on the transaction, now with its label.
    expect(openTransaction(), '48301');
    expect(inPanel(find.text('Actualizar etiqueta')), findsOneWidget);
  });

  testWidgets('?tx= outside the range moves the range to show it', (
    tester,
  ) async {
    await pumpScreen(tester, transactionId: '48308');

    expect(find.text('Claro Colombia'), findsOneWidget);
  });

  testWidgets('?at= from an alert moves the range to that day', (tester) async {
    final day = DateTime.now().subtract(const Duration(days: 45));
    String two(int n) => n.toString().padLeft(2, '0');

    await pumpScreen(
      tester,
      at: '${day.year}-${two(day.month)}-${two(day.day)}',
    );

    expect(find.text('Claro Colombia'), findsOneWidget);
  });

  testWidgets('an unknown customer shows an error', (tester) async {
    await pumpScreen(tester, customerId: 'missing');

    expect(find.byType(ErrorState), findsOneWidget);
  });
}
