import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository(delay: Duration.zero));
  tearDown(() => repository.dispose());

  test('any email and password open a session and notify it', () async {
    final changes = repository.authStateChanges().first;

    final analyst = await repository.signIn(
      email: ' Laura.Gomez@MonedaSegura.co ',
      password: 'secreto',
    );

    expect(analyst.email, 'laura.gomez@monedasegura.co');
    expect(analyst.fullName, 'Laura Gomez');
    expect(repository.currentAnalyst, analyst);
    expect(await changes, analyst);
  });

  test('the demo email fails with invalid credentials', () async {
    await expectLater(
      repository.signIn(
        email: FakeAuthRepository.invalidCredentialsEmail,
        password: 'secreto',
      ),
      throwsA(const Failure.invalidCredentials()),
    );
    expect(repository.currentAnalyst, isNull);
  });

  test('the network demo email fails with a network error', () async {
    await expectLater(
      repository.signIn(
        email: FakeAuthRepository.networkErrorEmail,
        password: 'secreto',
      ),
      throwsA(const Failure.network()),
    );
  });

  test('signing out clears the session', () async {
    await repository.signIn(email: 'ana@monedasegura.co', password: 'x');
    final changes = repository.authStateChanges().first;

    await repository.signOut();

    expect(repository.currentAnalyst, isNull);
    expect(await changes, isNull);
  });

  test('nameFromEmail builds a display name from the local part', () {
    expect(
      FakeAuthRepository.nameFromEmail('maria_fernanda.ruiz@x.co'),
      'Maria Fernanda Ruiz',
    );
    expect(FakeAuthRepository.nameFromEmail('@x.co'), 'Analista');
  });
}
