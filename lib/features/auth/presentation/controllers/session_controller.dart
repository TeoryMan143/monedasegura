import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../data/auth_repository.dart';
import '../../domain/analyst.dart';

/// The current session: the signed-in [Analyst] or null (HU-01).
///
/// Kept alive (app-wide state). It follows [AuthRepository.authStateChanges], so a sign
/// in or out anywhere updates it, and the router's redirect reacts through
/// [isSignedInProvider]. Screens never navigate after sign in or out.
final sessionProvider = NotifierProvider<SessionController, Analyst?>(
  SessionController.new,
  name: 'sessionProvider',
);

/// Whether an analyst is signed in. The router's `redirect` is driven by this.
final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(sessionProvider) != null,
  name: 'isSignedInProvider',
);

/// Holds the session and signs out (C-15 «Cerrar sesión»).
class SessionController extends Notifier<Analyst?> {
  @override
  Analyst? build() {
    final repository = ref.watch(authRepositoryProvider);
    final subscription = repository.authStateChanges().listen((analyst) {
      final analystChanged = analyst?.id != state?.id;
      state = analyst;
      if (analystChanged) invalidateCatalogs(ref);
    });
    ref.onDispose(subscription.cancel);
    return repository.currentAnalyst;
  }

  /// Ends the session. The router then goes back to the login by itself.
  ///
  /// Keep-alive providers with user data are invalidated in [build] whenever the analyst
  /// changes. That also covers an expired session, and a sign in replaces anything that
  /// failed to reload right after the session ended.
  Future<void> signOut() => ref.read(authRepositoryProvider).signOut();
}
