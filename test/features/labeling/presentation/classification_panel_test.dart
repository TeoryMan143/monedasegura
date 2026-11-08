import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/audit/data/audit_repository.dart';
import 'package:monedasegura/features/audit/data/fake_audit_repository.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/labeling/data/fake_labeling_repository.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/data/labeling_repository.dart';
import 'package:monedasegura/features/labeling/presentation/classification_panel.dart';

/// Unlabeled, with an AI alert.
const unlabeled = 48301;

/// Already labeled as fraud by another analyst.
const labeled = 48219;

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
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late LocalWritesStore store;
  late int saves;

  Future<void> pumpPanel(
    WidgetTester tester,
    int transactionId, {
    Set<int> failing = const {},
  }) async {
    saves = 0;
    store = LocalWritesStore(
      failingTransactionIds: failing,
      delay: Duration.zero,
    );
    tester.view
      ..physicalSize = const Size(1280, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          labelingRepositoryProvider.overrideWithValue(
            FakeLabelingRepository(LocalLabelWriter(store)),
          ),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
          auditRepositoryProvider.overrideWithValue(FakeAuditRepository(store)),
          sessionProvider.overrideWith(_SignedIn.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: AppLayout.sidePanelWidth,
                child: ClassificationPanel(
                  transactionId: transactionId,
                  onClose: () {},
                  onSaved: () => saves++,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the transaction and its AI alert', (tester) async {
    await pumpPanel(tester, unlabeled);

    expect(find.text('TX-48301'), findsOneWidget);
    expect(find.textContaining('1.900.000'), findsOneWidget);
    expect(find.textContaining('Alerta IA AL-1043'), findsOneWidget);
    expect(find.text('Guardar etiqueta'), findsOneWidget);
  });

  testWidgets('saving an empty form shows the required fields', (tester) async {
    await pumpPanel(tester, unlabeled);

    await tapText(tester, 'Guardar etiqueta');

    expect(find.text('Elige un veredicto.'), findsOneWidget);
    expect(find.text('Elige un nivel de confianza.'), findsOneWidget);
    expect(store.labelFor(unlabeled), isNull);
  });

  testWidgets('fraud asks for a type and a severity', (tester) async {
    await pumpPanel(tester, unlabeled);

    await tapText(tester, 'Fraude');
    await tapText(tester, 'Alta');
    await tapText(tester, 'Guardar etiqueta');

    expect(find.text('Elige al menos un tipo de fraude.'), findsOneWidget);
    expect(find.text('Elige una severidad.'), findsOneWidget);
  });

  testWidgets('No fraude hides types and severity', (tester) async {
    await pumpPanel(tester, unlabeled);

    await tapText(tester, 'No fraude');

    expect(
      find.textContaining('Tipo(s) de fraude', findRichText: true),
      findsNothing,
    );
    expect(find.textContaining('Severidad', findRichText: true), findsNothing);
  });

  testWidgets('low confidence needs a justification, then saves', (
    tester,
  ) async {
    await pumpPanel(tester, unlabeled);

    await tapText(tester, 'No fraude');
    await tapText(tester, 'Baja');
    await tapText(tester, 'Guardar etiqueta');
    expect(find.text('Explica por qué la confianza es baja.'), findsOneWidget);
    expect(store.labelFor(unlabeled), isNull);

    await tester.enterText(find.byType(TextField), 'Pago habitual del cliente');
    await tester.pumpAndSettle();
    await tapText(tester, 'Guardar etiqueta');

    expect(
      store.labelFor(unlabeled)?.values.justification,
      'Pago habitual del cliente',
    );
    expect(find.text('Etiqueta guardada'), findsOneWidget);
    expect(find.text('Actualizar etiqueta'), findsOneWidget);
    expect(saves, 1);
  });

  testWidgets('an existing label fills the form and shows who saved it', (
    tester,
  ) async {
    await pumpPanel(tester, labeled);

    expect(find.textContaining('Etiquetada por Mateo Rojas'), findsOneWidget);
    expect(find.text('Ver historial'), findsOneWidget);
    expect(find.text('Actualizar etiqueta'), findsOneWidget);
    expect(
      find.text('Cambio de clave y dispositivo nuevo minutos antes.'),
      findsOneWidget,
    );
  });

  testWidgets('Ver historial opens N-03 with the changes', (tester) async {
    await pumpPanel(tester, labeled);

    await tapText(tester, 'Ver historial');

    expect(find.text('Historial de la etiqueta'), findsOneWidget);
    expect(
      find.textContaining('Etiqueta editada', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('E-03: a failed save shows Reintentar and keeps the data', (
    tester,
  ) async {
    await pumpPanel(tester, unlabeled, failing: {unlabeled});

    await tapText(tester, 'No fraude');
    await tapText(tester, 'Media');
    await tester.enterText(find.byType(TextField), 'Compra conocida');
    await tester.pumpAndSettle();
    await tapText(tester, 'Guardar etiqueta');

    expect(find.text('No se guardó la etiqueta'), findsOneWidget);
    expect(find.text('Reintentar'), findsWidgets);
    expect(find.text('Compra conocida'), findsOneWidget);
    expect(store.labelFor(unlabeled), isNull);
    expect(saves, 0);
  });
}
