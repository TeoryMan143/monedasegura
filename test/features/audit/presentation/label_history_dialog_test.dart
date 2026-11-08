import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/audit/data/audit_repository.dart';
import 'package:monedasegura/features/audit/data/fake_audit_repository.dart';
import 'package:monedasegura/features/audit/presentation/label_history_dialog.dart';

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

  Future<void> pumpDialog(WidgetTester tester, int transactionId) async {
    tester.view
      ..physicalSize = const Size(1280, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          auditRepositoryProvider.overrideWithValue(FakeAuditRepository(store)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: LabelHistoryDialog(
              transactionId: transactionId,
              transactionCode: 'TX-$transactionId',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => store = LocalWritesStore(delay: Duration.zero));

  testWidgets('lists the changes newest first, before → after', (tester) async {
    await pumpDialog(tester, FakeAuditRepository.historyTransactionId);

    expect(find.text('Historial de la etiqueta · TX-48219'), findsOneWidget);
    expect(
      find.textContaining(
        RegExp(r'^Alerta AL-1042 · generada por la IA el .+ \(score 92\)$'),
      ),
      findsOneWidget,
    );
    final edited = tester.getTopLeft(
      find.textContaining('Etiqueta editada', findRichText: true),
    );
    final confirmed = tester.getTopLeft(
      find.textContaining('Alerta confirmada · AL-1042', findRichText: true),
    );
    final created = tester.getTopLeft(
      find.textContaining('Etiqueta creada', findRichText: true),
    );
    expect(edited.dy, lessThan(confirmed.dy));
    expect(confirmed.dy, lessThan(created.dy));
    expect(
      find.textContaining('Incierto → Fraude', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Pendiente → Confirmada', findRichText: true),
      findsOneWidget,
    );
    // Read only: no edit or delete actions.
    expect(find.text('Editar'), findsNothing);
    expect(find.text('Eliminar'), findsNothing);
  });

  testWidgets('a transaction without changes shows the empty state', (
    tester,
  ) async {
    await pumpDialog(tester, 48301);

    expect(
      find.text('Esta transacción aún no tiene cambios registrados.'),
      findsOneWidget,
    );
  });

  testWidgets('a label saved in this session shows first', (tester) async {
    await tester.runAsync(
      () => store.saveLabel(
        transactionId: FakeAuditRepository.historyTransactionId,
        values: const LabelValues(
          verdict: Verdict.notFraud,
          confidence: ConfidenceLevel.medium,
        ),
        analystId: 'a1',
        analystName: 'Juan Camilo Borrero',
      ),
    );

    await pumpDialog(tester, FakeAuditRepository.historyTransactionId);

    expect(find.text('En esta sesión'), findsOneWidget);
    expect(find.text('Juan Camilo Borrero'), findsOneWidget);
    expect(find.textContaining(RegExp('^ahora · ')), findsOneWidget);
  });
}
