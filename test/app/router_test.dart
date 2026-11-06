import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/app/app.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';

Future<void> _pumpApp(WidgetTester tester, {required bool signedIn}) async {
  tester.view
    ..physicalSize = const Size(1280, 720)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [isSignedInProvider.overrideWithValue(signedIn)],
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

    expect(find.textContaining('HU-02'), findsOneWidget);
  });

  testWidgets('the side menu switches branches', (tester) async {
    await _pumpApp(tester, signedIn: true);

    await tester.tap(find.text('Alertas IA'));
    await tester.pumpAndSettle();
    expect(find.textContaining('HU-06'), findsOneWidget);

    await tester.tap(find.text('Estadísticas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('HU-13'), findsOneWidget);
  });
}
