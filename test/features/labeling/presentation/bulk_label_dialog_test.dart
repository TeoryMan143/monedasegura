import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/labeling/data/fake_labeling_repository.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/data/labeling_repository.dart';
import 'package:monedasegura/features/labeling/presentation/bulk_label_confirm_dialog.dart';
import 'package:monedasegura/features/labeling/presentation/bulk_label_dialog.dart';
import 'package:monedasegura/features/transactions/data/fake_transactions_repository.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';
import 'package:monedasegura/features/transactions/presentation/transactions_screen.dart';

class _SignedIn extends SessionController {
  @override
  Analyst? build() => const Analyst(
    id: 'a1',
    email: 'laura.gomez@monedasegura.test',
    fullName: 'Laura Gómez',
  );
}

/// A-03 from A-01 (HU-05): the six rows of the prototype list, three of them labeled.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late LocalWritesStore store;

  Future<void> pumpList(
    WidgetTester tester, {
    Set<int> failing = const {},
  }) async {
    store = LocalWritesStore(
      delay: Duration.zero,
      failingTransactionIds: failing,
    );
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(
            FakeTransactionsRepository(store),
          ),
          labelingRepositoryProvider.overrideWithValue(
            FakeLabelingRepository(LocalLabelWriter(store)),
          ),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
          sessionProvider.overrideWith(_SignedIn.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(body: TransactionsScreen(onOpen: (_, _) {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Checks the whole page and opens A-03.
  Future<void> openDialog(WidgetTester tester) async {
    await tester.tap(
      find.bySemanticsLabel('Seleccionar todas las filas de la página'),
    );
    await tester.pump();
    await tester.tap(find.text('Clasificar 6 transacciones'));
    await tester.pumpAndSettle();
  }

  Finder inDialog(Finder finder) =>
      find.descendant(of: find.byType(BulkLabelDialog), matching: finder);

  Future<void> tapInDialog(WidgetTester tester, Finder finder) async {
    final target = inDialog(finder).first;
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// Fills A-03 for the structuring case: Fraude · LAV · Alta · Crítica.
  Future<void> fillStructuring(WidgetTester tester) async {
    await tapInDialog(tester, find.text('Fraude'));
    await tapInDialog(
      tester,
      find.textContaining(FraudType.laundering.code, findRichText: true),
    );
    // Confidence comes before severity, which also has «Alta».
    await tapInDialog(tester, find.text('Alta'));
    await tapInDialog(tester, find.text('Crítica'));
  }

  Finder inConfirmation(Finder finder) => find.descendant(
    of: find.byType(BulkLabelConfirmDialog),
    matching: finder,
  );

  Future<void> tapApply(WidgetTester tester) async {
    await tester.tap(
      find.descendant(
        of: find.byType(BulkLabelDialog),
        matching: find.text('Aplicar a 6 transacciones'),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('A-03 sums up the selection and warns about labels it replaces', (
    tester,
  ) async {
    await pumpList(tester);
    await openDialog(tester);

    expect(find.text('3 sin etiquetar · 3 ya etiquetadas'), findsOneWidget);
    expect(find.text('3 transacciones ya tienen etiqueta'), findsOneWidget);
  });

  testWidgets('an incomplete form does not reach the confirmation', (
    tester,
  ) async {
    await pumpList(tester);
    await openDialog(tester);

    await tapApply(tester);

    expect(find.byType(BulkLabelConfirmDialog), findsNothing);
    expect(inDialog(find.text('Elige un veredicto.')), findsOneWidget);
    expect(inDialog(find.text('Elige un nivel de confianza.')), findsOneWidget);
    expect(store.labeledTransactionIds, isEmpty);
  });

  testWidgets('the confirmation counts, then applies, refreshes and clears', (
    tester,
  ) async {
    await pumpList(tester);
    await openDialog(tester);
    await fillStructuring(tester);

    await tapApply(tester);
    expect(
      inConfirmation(find.text('¿Aplicar la clasificación a 6 transacciones?')),
      findsOneWidget,
    );
    expect(
      inConfirmation(
        find.text(
          'Fraude · LAV Lavado / fraccionamiento · Confianza Alta · '
          'Severidad Crítica',
        ),
      ),
      findsOneWidget,
    );
    expect(
      inConfirmation(find.text('3 transacciones que ya tenían etiqueta')),
      findsOneWidget,
    );
    expect(inConfirmation(find.text('3 etiquetas nuevas')), findsOneWidget);

    await tester.tap(inConfirmation(find.text('Aplicar a 6 transacciones')));
    await tester.pumpAndSettle();

    expect(store.labeledTransactionIds, hasLength(6));
    expect(find.byType(BulkLabelDialog), findsNothing);
    expect(
      find.text('Clasificación aplicada a 6 transacciones'),
      findsOneWidget,
    );
    // The table shows the new labels and the selection is gone.
    expect(find.text('6 transacciones · 0 sin etiquetar'), findsOneWidget);
    expect(find.text('Quitar selección'), findsNothing);
  });

  testWidgets('cancelling the confirmation saves nothing', (tester) async {
    await pumpList(tester);
    await openDialog(tester);
    await fillStructuring(tester);

    await tapApply(tester);
    await tester.tap(inConfirmation(find.text('Cancelar')));
    await tester.pumpAndSettle();

    expect(find.byType(BulkLabelConfirmDialog), findsNothing);
    expect(find.byType(BulkLabelDialog), findsOneWidget);
    expect(store.labeledTransactionIds, isEmpty);
  });

  testWidgets('a failed save keeps A-03 open with the error', (tester) async {
    await pumpList(tester, failing: {48219});
    await openDialog(tester);
    await fillStructuring(tester);

    await tapApply(tester);
    await tester.tap(inConfirmation(find.text('Aplicar a 6 transacciones')));
    await tester.pumpAndSettle();

    expect(find.byType(BulkLabelDialog), findsOneWidget);
    expect(find.text('No se aplicó la clasificación'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(SaveStatus),
        matching: find.text('Reintentar'),
      ),
      findsOneWidget,
    );
    expect(store.labeledTransactionIds, isEmpty);
    // The selection is still there for the retry.
    expect(find.text('6 seleccionadas'), findsOneWidget);
  });
}
