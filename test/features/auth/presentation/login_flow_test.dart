import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/app/app.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/auth/data/auth_repository.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';

const _latency = Duration(milliseconds: 50);

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view
    ..physicalSize = const Size(1280, 720)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWith((ref) {
          final repository = FakeAuthRepository(delay: _latency);
          ref.onDispose(repository.dispose);
          return repository;
        }),
      ],
      child: const MonedaSeguraApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _signIn(
  WidgetTester tester, {
  required String email,
  String password = 'secreto',
}) async {
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), email);
  await tester.enterText(fields.at(1), password);
  await tester.tap(find.byType(AppButton));
  await tester.pump(_latency * 2);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('invalid credentials show one generic message (C-02)', (
    tester,
  ) async {
    await _pumpApp(tester);

    await _signIn(tester, email: FakeAuthRepository.invalidCredentialsEmail);

    expect(find.text('Correo o contraseña incorrectos'), findsOneWidget);
    expect(find.text('Alertas IA'), findsNothing);
  });

  testWidgets('empty fields are reported before calling the repository', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(find.text('Escribe tu correo.'), findsOneWidget);
    expect(find.text('Escribe tu contraseña.'), findsOneWidget);
  });

  testWidgets('signing in opens the transactions and signing out goes back', (
    tester,
  ) async {
    await _pumpApp(tester);

    await _signIn(tester, email: 'laura.gomez@monedasegura.co');
    expect(find.textContaining('HU-02'), findsOneWidget);
    expect(find.text('Laura Gomez'), findsOneWidget);

    await tester.tap(find.text('Laura Gomez'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pump(_latency);
    await tester.pumpAndSettle();

    expect(find.text('Ingresa con tu cuenta de analista.'), findsOneWidget);
  });
}
