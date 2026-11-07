import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/analyst.dart';
import 'fake_auth_repository.dart';
import 'supabase_auth_repository.dart';

/// Sign in and out with email and password (HU-01).
///
/// Implementations throw a `Failure`: `invalidCredentials` for a wrong email or
/// password (never saying which one), `network` when the server cannot be reached.
abstract interface class AuthRepository {
  /// The analyst with an open session, or null.
  Analyst? get currentAnalyst;

  /// Emits the analyst on sign in and null on sign out.
  Stream<Analyst?> authStateChanges();

  Future<Analyst> signIn({required String email, required String password});

  Future<void> signOut();
}

/// The auth repository of the app: [SupabaseAuthRepository], real Supabase Auth.
///
/// With `--dart-define=USE_FAKE_DATA=true` (no backend) it is [FakeAuthRepository], an
/// in-memory session; tests override it the same way.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (Env.useFakeData) {
    final repository = FakeAuthRepository();
    ref.onDispose(repository.dispose);
    return repository;
  }
  final repository = SupabaseAuthRepository(ref.watch(supabaseClientProvider));
  ref.onDispose(repository.dispose);
  return repository;
}, name: 'authRepositoryProvider');
