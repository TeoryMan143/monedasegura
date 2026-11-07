import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/presentation/alerts_screen.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';

class _MockRepository extends Mock implements AlertsRepository {}

AiAlert _alert(String id, String customer, int score, FraudType type) =>
    AiAlert(
      id: id,
      code: 'AL-$id',
      customerId: 'c$id',
      customerName: customer,
      score: score,
      suggestedType: type,
      summary: 'Resumen de $customer',
      status: AlertStatus.pending,
      generatedAt: DateTime(2026, 11, 5, 9, 41),
    );

void main() {
  setUpAll(() async {
    registerFallbackValue(const AlertsQuery());
    await initializeDateFormatting('es');
    // The real font, so widths in the test match the app.
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late _MockRepository repository;

  setUp(() => repository = _MockRepository());

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [alertsRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('es'),
          supportedLocales: const [Locale('es')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: const Scaffold(body: AlertsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the alerts in the order received, with their score', (
    tester,
  ) async {
    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [
          _alert('1', 'Juan Pérez', 92, FraudType.accountTakeover),
          _alert('2', 'Pedro Alves', 88, FraudType.moneyMule),
          _alert('3', 'María Gómez', 76, FraudType.laundering),
        ],
        total: 3,
      ),
    );

    await pumpScreen(tester);

    expect(find.text('Bandeja de alertas IA'), findsOneWidget);
    expect(find.text('92'), findsOneWidget);
    expect(find.text('88'), findsOneWidget);
    expect(find.text('76'), findsOneWidget);
    expect(find.text('Robo de cuenta'), findsOneWidget);
    expect(find.text('AL-1'), findsOneWidget);

    final top = [
      for (final name in ['Juan Pérez', 'Pedro Alves', 'María Gómez'])
        tester.getTopLeft(find.text(name)).dy,
    ];
    expect(top, [...top]..sort());
  });

  testWidgets('shows the empty state when there are no pending alerts', (
    tester,
  ) async {
    when(() => repository.list(any()))
        .thenAnswer((_) async => const PageResult(items: [], total: 0));

    await pumpScreen(tester);

    expect(find.text('No hay alertas pendientes'), findsOneWidget);
  });

  testWidgets('shows the error and retries when the network fails', (
    tester,
  ) async {
    when(() => repository.list(any())).thenThrow(const Failure.network());

    await pumpScreen(tester);

    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    when(() => repository.list(any())).thenAnswer(
      (_) async => PageResult(
        items: [_alert('1', 'Juan Pérez', 92, FraudType.accountTakeover)],
        total: 1,
      ),
    );
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Juan Pérez'), findsOneWidget);
  });
}
