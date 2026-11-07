import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/features/auth/data/supabase_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockClient extends Mock implements SupabaseClient {}

class _MockAuth extends Mock implements GoTrueClient {}

void main() {
  late _MockAuth auth;
  late SupabaseAuthRepository repository;

  setUp(() {
    final client = _MockClient();
    auth = _MockAuth();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);
    when(() => auth.onAuthStateChange).thenAnswer((_) => const Stream.empty());
    repository = SupabaseAuthRepository(client);
  });

  tearDown(() => repository.dispose());

  void stubSignIn(AuthException error) {
    when(
      () => auth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(error);
  }

  test('starts without a session when Supabase has none', () {
    expect(repository.currentAnalyst, isNull);
  });

  test('a rejected email or password is invalid credentials (C-02)', () async {
    stubSignIn(
      const AuthException(
        'Invalid login credentials',
        statusCode: '400',
        code: 'invalid_credentials',
      ),
    );

    await expectLater(
      repository.signIn(email: 'ana@monedasegura.co', password: 'x'),
      throwsA(const Failure.invalidCredentials()),
    );
  });

  test('an unconfirmed or unknown email does not reveal it', () async {
    stubSignIn(
      const AuthException(
        'Email not confirmed',
        statusCode: '400',
        code: 'email_not_confirmed',
      ),
    );

    await expectLater(
      repository.signIn(email: 'nadie@monedasegura.co', password: 'x'),
      throwsA(const Failure.invalidCredentials()),
    );
  });

  test('no answer from the server is a network failure', () async {
    stubSignIn(const AuthException('Failed host lookup'));

    await expectLater(
      repository.signIn(email: 'ana@monedasegura.co', password: 'x'),
      throwsA(const Failure.network()),
    );
  });

  test('signing out clears the session even if the request fails', () async {
    when(() => auth.signOut()).thenThrow(const AuthException('offline'));
    final changes = repository.authStateChanges().first;

    await repository.signOut();

    expect(await changes, isNull);
    expect(repository.currentAnalyst, isNull);
  });
}
