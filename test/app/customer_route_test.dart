import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/app/app.dart';
import 'package:monedasegura/app/router.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/realtime/realtime_service.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/auth/data/auth_repository.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/presentation/customer_screen.dart';
import 'package:monedasegura/features/labeling/data/fake_labeling_repository.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/data/labeling_repository.dart';
import 'package:monedasegura/features/notifications/data/notifications_repository.dart';
import 'package:monedasegura/features/transactions/data/fake_transactions_repository.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';
import 'package:monedasegura/features/transactions/presentation/transactions_screen.dart';
import 'package:monedasegura/features/transactions/presentation/widgets/transactions_search_field.dart';

import '../helpers/shell_overrides.dart' show FakeNotificationsRepository;

class _SignedIn extends SessionController {
  @override
  Analyst? build() => const Analyst(
    id: 'a1',
    email: 'laura.gomez@monedasegura.test',
    fullName: 'Laura Gómez',
  );
}

/// The open transaction of A-02 lives in `?tx=` (HU-03, HU-04), written with
/// `context.replace` so the list stays below.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    // The real font, so the rows of the tables fit as in the app.
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  late GoRouter router;

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1280, 720)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final store = LocalWritesStore(delay: Duration.zero);
    final overrides = [
      sessionProvider.overrideWith(_SignedIn.new),
      authRepositoryProvider.overrideWith((ref) => FakeAuthRepository()),
      notificationsRepositoryProvider.overrideWithValue(
        FakeNotificationsRepository(),
      ),
      realtimeServiceProvider.overrideWith((ref) {
        final service = FakeRealtimeService(
          newAlertDelay: const Duration(hours: 1),
        );
        ref.onDispose(service.dispose);
        return service;
      }),
      catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
      transactionsRepositoryProvider.overrideWithValue(
        FakeTransactionsRepository(store),
      ),
      customerRepositoryProvider.overrideWithValue(
        FakeCustomerRepository(store),
      ),
      labelingRepositoryProvider.overrideWithValue(
        FakeLabelingRepository(LocalLabelWriter(store)),
      ),
    ];
    // A ProviderScope, not a container of the test: it is disposed with the tree, so
    // the timers of the fake realtime service end with the test.
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const MonedaSeguraApp()),
    );
    await tester.pumpAndSettle();
    router = ProviderScope.containerOf(
      tester.element(find.byType(MonedaSeguraApp)),
    ).read(routerProvider);
  }

  Uri location() => router.state.uri;

  testWidgets('Siguiente updates ?tx= and back keeps the list as it was', (
    tester,
  ) async {
    await pumpApp(tester);

    // A search on A-01, which must survive the trip to the customer view.
    await tester.enterText(
      find.descendant(
        of: find.byType(TransactionsSearchField),
        matching: find.byType(EditableText),
      ),
      'rojas',
    );
    await tester.pump(TransactionsSearchField.debounce);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ana María Rojas'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerScreen), findsOneWidget);
    expect(location().queryParameters['tx'], '48219');
    expect(find.text('TX-48219'), findsOneWidget);

    // Rows of A-02: 48301, 48219, 48302…
    await tester.ensureVisible(find.text('Siguiente'));
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(location().queryParameters['tx'], '48302');
    expect(find.text('TX-48302'), findsOneWidget);

    await tester.tap(find.byTooltip('Cerrar panel'));
    await tester.pumpAndSettle();
    expect(location().path, '/customers/${FakeCustomerRepository.customerId}');
    expect(location().queryParameters, isEmpty);

    // Back to the list: replace kept it below, with its search.
    await tester.tap(
      find.descendant(
        of: find.byType(Breadcrumbs),
        matching: find.text('Transacciones'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TransactionsScreen), findsOneWidget);
    expect(find.text('rojas'), findsOneWidget);
  });
}
