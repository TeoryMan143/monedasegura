import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/catalog_providers.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_provider.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/auth/data/auth_repository.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';

import '../../../helpers/counting_catalog_repository.dart';

void main() {
  late FakeAuthRepository auth;
  late CountingCatalogRepository catalogs;
  late ProviderContainer container;

  Future<void> signIn() async {
    await auth.signIn(email: 'laura.gomez@banco.test', password: 'secreto');
    await container.pump();
  }

  setUp(() {
    auth = FakeAuthRepository(delay: Duration.zero);
    catalogs = CountingCatalogRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        catalogRepositoryProvider.overrideWithValue(catalogs),
        localWritesStoreProvider.overrideWithValue(
          LocalWritesStore(delay: Duration.zero),
        ),
      ],
    );
    addTearDown(() {
      container.dispose();
      auth.dispose();
    });
    container.read(sessionProvider);
  });

  test('signing out invalidates the catalogs', () async {
    await signIn();
    await container.read(currenciesProvider.future);
    expect(catalogs.currencyLoads, 1);

    await container.read(sessionProvider.notifier).signOut();
    await container.pump();

    expect(container.read(sessionProvider), isNull);
    await container.read(currenciesProvider.future);
    expect(catalogs.currencyLoads, 2);
  });

  test('signing out clears the local writes', () async {
    await signIn();
    final store = container.read(localWritesStoreProvider);
    await store.saveLabel(
      transactionId: 1,
      values: const LabelValues(
        verdict: Verdict.notFraud,
        confidence: ConfidenceLevel.high,
      ),
      analystId: 'a1',
      analystName: 'Laura',
    );

    await container.read(sessionProvider.notifier).signOut();
    await container.pump();

    expect(store.labelFor(1), isNull);
    expect(store.auditFor(1), isEmpty);
  });

  test('a catalog that failed in the old session reloads on sign in', () async {
    await signIn();
    await container.read(sessionProvider.notifier).signOut();
    await container.pump();

    catalogs.countriesError = StateError('sin sesión');
    final failed = container.listen(countriesProvider, (_, _) {});
    await container.pump();
    expect(failed.read().hasError, isTrue);
    failed.close();

    catalogs.countriesError = null;
    await signIn();

    expect(await container.read(countriesProvider.future), isNotEmpty);
  });

  test('the same analyst emitted again keeps the catalogs', () async {
    await signIn();
    await container.read(currenciesProvider.future);

    await signIn();
    await container.read(currenciesProvider.future);

    expect(catalogs.currencyLoads, 1);
  });
}
