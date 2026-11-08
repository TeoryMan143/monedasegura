import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alert_detail.dart';
import 'package:monedasegura/features/alerts/domain/alert_transaction.dart';
import 'package:monedasegura/features/alerts/domain/resolve_alert_input.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/alerts/presentation/resolve_alert_dialog.dart';

/// A-06 (HU-08): an alert of two transactions, the first one already labeled.
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
    generatedAt: DateTime.utc(2026, 11, 5),
  ),
  modelVersion: 'v2.1',
  reasons: const [],
  transactions: const [
    AlertTransaction(
      transactionId: 10,
      code: 'TX-10',
      isPrimary: true,
      amount: 84500,
      currencyCode: 'MXN',
      isLabeled: true,
    ),
    AlertTransaction(
      transactionId: 11,
      code: 'TX-11',
      isPrimary: false,
      amount: 41000,
      currencyCode: 'MXN',
    ),
  ],
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late List<ResolveAlertInput> sent;
  Failure? failToThrow;

  Future<void> openDialog(WidgetTester tester) async {
    sent = [];
    failToThrow = null;
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          alertDetailProvider('a1').overrideWith((ref) async => _detail),
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
          resolveAlertProvider.overrideWithValue((input) async {
            final failure = failToThrow;
            if (failure != null) throw failure;
            sent.add(input);
          }),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () =>
                      showResolveAlertDialog(context: context, alertId: 'a1'),
                  child: const Text('Abrir'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text).first;
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  AppButton button(WidgetTester tester, String label) =>
      tester.widget<AppButton>(find.widgetWithText(AppButton, label));

  /// Field labels draw a red « *» after the text, so they are rich text.
  Finder label(String text) => find.textContaining(text, findRichText: true);

  Finder chip(String code) => find.byWidgetPredicate(
    (widget) => widget is TaxonomyChip && widget.code == code,
  );

  testWidgets('opens on Confirmar with the suggested type locked', (
    tester,
  ) async {
    await openDialog(tester);

    expect(find.text('Resolver alerta AL-1042'), findsOneWidget);
    expect(
      find.text('Sugerido por la IA · no editable al confirmar'),
      findsOne,
    );
    expect(chip('ATO'), findsOneWidget);
    expect(label('Severidad'), findsOneWidget);
    expect(
      button(tester, 'Confirmar fraude').variant,
      AppButtonVariant.primary,
    );
  });

  testWidgets('Rechazar hides the type and the severity and turns red', (
    tester,
  ) async {
    await openDialog(tester);

    await tapText(tester, 'Rechazar');

    expect(label('Tipo de fraude'), findsNothing);
    expect(label('Severidad'), findsNothing);
    expect(label('Confianza'), findsOneWidget);
    expect(button(tester, 'Rechazar alerta').variant, AppButtonVariant.danger);
  });

  testWidgets('Reclasificar offers every type but the suggested one', (
    tester,
  ) async {
    await openDialog(tester);

    await tapText(tester, 'Reclasificar');

    expect(chip('ATO'), findsNothing);
    expect(chip('PHI'), findsOneWidget);
    expect(
      find.text('Sugerido por la IA · no editable al confirmar'),
      findsNothing,
    );
    expect(
      button(tester, 'Reclasificar alerta').variant,
      AppButtonVariant.primary,
    );
  });

  testWidgets('sending an incomplete form shows the errors and sends nothing', (
    tester,
  ) async {
    await openDialog(tester);
    expect(find.text('Elige una severidad.'), findsNothing);

    await tapText(tester, 'Confirmar fraude');

    expect(find.text('Elige una severidad.'), findsOneWidget);
    expect(find.text('Elige un nivel de confianza.'), findsOneWidget);
    expect(sent, isEmpty);
  });

  testWidgets('unchecking a transaction changes the summary sentence', (
    tester,
  ) async {
    await openDialog(tester);
    expect(
      find.textContaining('2 transacciones como Fraude · Robo de cuenta'),
      findsOneWidget,
    );
    expect(find.textContaining('1 ya tenía etiqueta'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Etiquetar TX-10'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Se etiquetará 1 transacción'), findsOneWidget);
    expect(find.textContaining('ya tenía etiqueta'), findsNothing);
  });

  testWidgets('with every transaction unchecked it cannot be sent', (
    tester,
  ) async {
    await openDialog(tester);
    await tester.tap(find.bySemanticsLabel('Etiquetar TX-10'));
    await tester.tap(find.bySemanticsLabel('Etiquetar TX-11'));
    await tester.pumpAndSettle();

    await tapText(tester, 'Confirmar fraude');

    expect(find.text('Deja al menos una transacción marcada.'), findsOneWidget);
    expect(sent, isEmpty);
  });

  testWidgets('a complete form is sent and the dialog closes', (tester) async {
    await openDialog(tester);
    await tapText(tester, 'Muy alta');
    await tapText(tester, 'Crítica');

    await tapText(tester, 'Confirmar fraude');

    expect(sent.single.action, ResolveAlertAction.confirm);
    expect(find.byType(AppDialog), findsNothing);
    expect(find.text('Alerta AL-1042 confirmada'), findsOneWidget);
  });

  testWidgets('a conflict keeps the dialog open and offers only «Cerrar»', (
    tester,
  ) async {
    await openDialog(tester);
    await tapText(tester, 'Muy alta');
    await tapText(tester, 'Crítica');
    failToThrow = const Failure.conflict(key: 'alert_already_resolved');

    await tapText(tester, 'Confirmar fraude');

    expect(find.text('Otro analista ya resolvió esta alerta.'), findsOneWidget);
    expect(find.text('Cerrar'), findsWidgets);
    expect(find.text('Confirmar fraude'), findsNothing);
    expect(find.text('Cancelar'), findsNothing);
  });

  testWidgets('Esc closes the dialog', (tester) async {
    await openDialog(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.byType(AppDialog), findsNothing);
  });
}
