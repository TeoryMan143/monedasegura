import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/app/realtime_session.dart';
import 'package:monedasegura/core/realtime/fake_realtime_service.dart';
import 'package:monedasegura/core/realtime/realtime_service.dart';
import 'package:monedasegura/features/auth/data/auth_repository.dart';
import 'package:monedasegura/features/auth/data/fake_auth_repository.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';

void main() {
  test('channels open after sign in and close on sign out', () async {
    final auth = FakeAuthRepository(delay: Duration.zero);
    final realtime = FakeRealtimeService();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => auth),
        realtimeServiceProvider.overrideWith((ref) => realtime),
      ],
    );
    addTearDown(() {
      container.dispose();
      realtime.dispose();
      auth.dispose();
    });
    final subscription = container.listen(realtimeSessionProvider, (_, _) {});
    addTearDown(subscription.close);
    expect(realtime.analystId, isNull);

    final analyst = await auth.signIn(
      email: 'laura.gomez@monedasegura.co',
      password: 'secreta',
    );
    await Future<void>.delayed(Duration.zero);
    container.read(realtimeSessionProvider);
    expect(realtime.analystId, analyst.id);

    await auth.signOut();
    await Future<void>.delayed(Duration.zero);
    container.read(realtimeSessionProvider);
    expect(realtime.analystId, isNull);
  });
}
