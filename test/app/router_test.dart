import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/app/app.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alert_detail.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/presentation/alerts_screen.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/auth/data/auth_repository.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/transactions/presentation/transactions_screen.dart';

import '../helpers/shell_overrides.dart';

class _MockAlertsRepository extends Mock implements AlertsRepository {}

Future<void> _pumpApp(
  WidgetTester tester, {
  required bool signedIn,
  List<AiAlert> alerts = const [],
}) async {
  tester.view
    ..physicalSize = const Size(1280, 720)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  registerFallbackValue(const AlertsQuery());
  final repository = _MockAlertsRepository();
  when(() => repository.list(any())).thenAnswer(
    (_) async => PageResult<AiAlert>(items: alerts, total: alerts.length),
  );

  when(() => repository.getById(any())).thenAnswer(
    (_) async => AlertDetail(
      alert: _alert,
      modelVersion: 'v1',
      reasons: const [],
      transactions: const [],
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isSignedInProvider.overrideWithValue(signedIn),
        authRepositoryProvider.overrideWith((ref) => FakeAuthRepository()),
        alertsRepositoryProvider.overrideWithValue(repository),
        ...shellOverrides(),
      ],
      child: const MonedaSeguraApp(),
    ),
  );
  await tester.pumpAndSettle();
}

final _alert = AiAlert(
  id: 'a1',
  code: 'AL-1042',
  customerId: 'c1',
  customerName: 'Juan Pérez',
  score: 92,
  suggestedType: FraudType.accountTakeover,
  summary: 'Resumen',
  status: AlertStatus.pending,
  generatedAt: DateTime(2026, 11, 5, 9, 41),
);

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

  testWidgets('without a session the app shows the login', (tester) async {
    await _pumpApp(tester, signedIn: false);

    expect(find.text('Ingresa con tu cuenta de analista.'), findsOneWidget);
    expect(find.text('Alertas IA'), findsNothing);
  });

  testWidgets('with a session the app opens the transactions branch', (
    tester,
  ) async {
    await _pumpApp(tester, signedIn: true);

    expect(find.byType(TransactionsScreen), findsOneWidget);
  });

  testWidgets('the side menu switches branches', (tester) async {
    await _pumpApp(tester, signedIn: true);

    await tester.tap(find.text('Alertas IA'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertsScreen), findsOneWidget);

    await tester.tap(find.text('Estadísticas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('HU-13'), findsOneWidget);
  });

  testWidgets('a click on an alert opens its detail route', (tester) async {
    await _pumpApp(tester, signedIn: true, alerts: [_alert]);

    await tester.tap(find.text('Alertas IA'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Juan Pérez'));
    await tester.pumpAndSettle();

    expect(find.text('Alerta AL-1042 · Juan Pérez'), findsOneWidget);
  });
}
