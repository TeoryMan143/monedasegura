import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/transactions/data/fake_transactions_repository.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';
import 'package:monedasegura/features/transactions/domain/transaction_row.dart';
import 'package:monedasegura/features/transactions/domain/transactions_query.dart';
import 'package:monedasegura/features/transactions/presentation/transactions_screen.dart';
import 'package:monedasegura/features/transactions/presentation/widgets/transactions_search_field.dart';

/// Never answers: the screen stays in its loading state (E-01).
class _PendingRepository extends FakeTransactionsRepository {
  _PendingRepository() : super(LocalWritesStore());

  @override
  Future<PageResult<TransactionRow>> fetchPage(
    TransactionsQuery query, {
    required List<CatalogCountry> countries,
  }) => Completer<PageResult<TransactionRow>>().future;
}

/// Always fails as if the network were down.
class _FailingRepository extends FakeTransactionsRepository {
  _FailingRepository() : super(LocalWritesStore());

  @override
  Future<PageResult<TransactionRow>> fetchPage(
    TransactionsQuery query, {
    required List<CatalogCountry> countries,
  }) async => throw const Failure.network();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    // The real font, so widths in the test match the app (the default test font is
    // much wider).
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late List<String> opened;

  Future<void> pumpScreen(
    WidgetTester tester, {
    TransactionsRepository? repository,
  }) async {
    opened = [];
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(
            repository ?? FakeTransactionsRepository(LocalWritesStore()),
          ),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: TransactionsScreen(
              onOpen: (customerId, transactionId) =>
                  opened.add('$customerId?tx=$transactionId'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder inPanel(Finder finder) =>
      find.descendant(of: find.byType(SidePanel), matching: finder);

  testWidgets('shows the page with its cells, count and pagination', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.text('Ana María Rojas'), findsOneWidget);
    expect(find.text('Ah •••• 4417 · CO'), findsOneWidget);
    expect(find.text(r'$ 1.900.000,00'), findsOneWidget);
    expect(find.text('92'), findsOneWidget);
    expect(find.text('Fraude'), findsOneWidget);
    // Credits carry a plus.
    expect(find.text(r'+R$ 12.400,00'), findsOneWidget);
    expect(find.text('6 transacciones · 3 sin etiquetar'), findsOneWidget);
    expect(find.text('Mostrando 1–6 de 6 transacciones'), findsOneWidget);
  });

  testWidgets('a click on a row opens it; the checkbox only selects', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.bySemanticsLabel('Seleccionar fila').first);
    await tester.pump();
    expect(opened, isEmpty);

    await tester.tap(find.text('Lucía Quispe'));
    await tester.pump();
    expect(opened, ['00000000-0000-4000-8000-000000000003?tx=48221']);
  });

  testWidgets('the search waits for the analyst to stop typing', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.enterText(
      find.descendant(
        of: find.byType(TransactionsSearchField),
        matching: find.byType(EditableText),
      ),
      'quispe',
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Ana María Rojas'), findsOneWidget);

    await tester.pump(TransactionsSearchField.debounce);
    await tester.pumpAndSettle();
    expect(find.text('Ana María Rojas'), findsNothing);
    expect(find.text('Lucía Quispe'), findsOneWidget);
    expect(find.text('1 transacción · 0 sin etiquetar'), findsOneWidget);
  });

  testWidgets('no results offers to clear the filters (E-02)', (tester) async {
    await pumpScreen(tester);

    await tester.enterText(
      find.descendant(
        of: find.byType(TransactionsSearchField),
        matching: find.byType(EditableText),
      ),
      'zzz',
    );
    await tester.pump(TransactionsSearchField.debounce);
    await tester.pumpAndSettle();
    expect(find.text('Sin resultados'), findsOneWidget);
    expect(find.text('0 resultados'), findsOneWidget);

    await tester.tap(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();
    expect(find.text('Ana María Rojas'), findsOneWidget);
    expect(find.text('zzz'), findsNothing);
  });

  testWidgets('the panel filters only when applied, and a chip removes it', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.widgetWithText(AppButton, 'Filtros'));
    await tester.pumpAndSettle();
    await tester.tap(inPanel(find.text('Sin etiquetar')));
    await tester.tap(inPanel(find.text('Pix')));
    await tester.pumpAndSettle();
    expect(inPanel(find.text('2 activos')), findsOneWidget);
    // The list does not change until «Aplicar filtros».
    expect(find.text('6 transacciones · 3 sin etiquetar'), findsOneWidget);

    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();
    expect(find.byType(SidePanel), findsNothing);
    expect(
      find.text('Etiqueta: Sin etiquetar', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Canal: Pix', findRichText: true), findsOneWidget);
    // Unlabeled Pix transactions: none in the prototype data.
    expect(find.text('No quedan transacciones sin etiquetar'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Quitar filtro Canal: Pix'));
    await tester.pumpAndSettle();
    expect(find.text('3 transacciones · 3 sin etiquetar'), findsOneWidget);
    expect(find.text('Ana María Rojas'), findsOneWidget);
    expect(find.text('Lucía Quispe'), findsNothing);
  });

  testWidgets('the Monto header sorts by amount, then flips it', (
    tester,
  ) async {
    await pumpScreen(tester);
    double top(String name) => tester.getTopLeft(find.text(name)).dy;

    await tester.tap(find.bySemanticsLabel(RegExp('^Ordenar por Monto')));
    await tester.pumpAndSettle();
    expect(top('Ana María Rojas'), lessThan(top('Lucía Quispe')));
    expect(find.text('Monto (mayor a menor)'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Ordenar por Monto,')));
    await tester.pumpAndSettle();
    expect(top('Lucía Quispe'), lessThan(top('Ana María Rojas')));
    expect(find.text('Monto (menor a mayor)'), findsOneWidget);
  });

  testWidgets('while the page loads it shows skeleton rows (E-01)', (
    tester,
  ) async {
    await pumpScreen(tester, repository: _PendingRepository());

    expect(find.byType(SkeletonRow), findsWidgets);
    expect(find.text('Cargando transacciones…'), findsOneWidget);
  });

  testWidgets('an error explains it and offers to retry', (tester) async {
    await pumpScreen(tester, repository: _FailingRepository());

    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text('Ana María Rojas'), findsNothing);
  });
}
