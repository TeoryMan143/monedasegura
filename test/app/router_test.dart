import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/app/app.dart';
import 'package:monedasegura/core/domain/page_result.dart';
import 'package:monedasegura/features/alerts/data/alerts_repository.dart';
import 'package:monedasegura/features/alerts/domain/ai_alert.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/presentation/alerts_screen.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_providers.dart';
import 'package:monedasegura/features/auth/data/auth_repository.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/transactions/presentation/transactions_screen.dart';

import '../helpers/shell_overrides.dart';

class _MockAlertsRepository extends Mock implements AlertsRepository {}

Future<void> _pumpApp(WidgetTester tester, {required bool signedIn}) async {
  tester.view
    ..physicalSize = const Size(1280, 720)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  registerFallbackValue(const AlertsQuery());
  final alerts = _MockAlertsRepository();
  when(() => alerts.list(any()))
      .thenAnswer((_) async => const PageResult<AiAlert>(items: [], total: 0));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isSignedInProvider.overrideWithValue(signedIn),
        authRepositoryProvider.overrideWith((ref) => FakeAuthRepository()),
        alertsRepositoryProvider.overrideWithValue(alerts),
        ...shellOverrides(),
      ],
      child: const MonedaSeguraApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
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
}
