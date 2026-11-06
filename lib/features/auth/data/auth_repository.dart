import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/analyst.dart';
import 'fake_auth_repository.dart';

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

/// The auth repository of the app.
///
/// Prototype: [FakeAuthRepository], an in-memory session. In S4 this line returns a
/// `SupabaseAuthRepository(ref.watch(supabaseClientProvider))`; nothing else changes.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = FakeAuthRepository();
  ref.onDispose(repository.dispose);
  return repository;
}, name: 'authRepositoryProvider');
