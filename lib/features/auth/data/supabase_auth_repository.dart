import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../domain/analyst.dart';
import 'auth_repository.dart';

/// [AuthRepository] on Supabase Auth with email and password (HU-01).
///
/// - `supabase_flutter` stores the session on disk, so it survives closing the app
///   until it is closed or expires; [currentAnalyst] reads it at start.
/// - [authStateChanges] follows `onAuthStateChange`: sign in, sign out, expired
///   session. The router's redirect reacts to it through the session provider.
/// - The analyst's name comes from `analysts.full_name`, then from the user metadata,
///   then from the email.
/// - Any rejection of the email or password is reported as
///   `Failure.invalidCredentials`, so the UI never reveals whether the email exists
///   (C-02). A server that cannot be reached is `Failure.network`.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client) {
    final user = _client.auth.currentUser;
    if (user != null) {
      _current = _fromUser(user);
      unawaited(_loadFullName(user));
    }
    _subscription = _client.auth.onAuthStateChange.listen(
      _onAuthState,
      // A failed token refresh also emits `signedOut`, which is what matters here.
      onError: (Object _) {},
    );
  }

  final SupabaseClient _client;
  final _changes = StreamController<Analyst?>.broadcast();
  late final StreamSubscription<AuthState> _subscription;
  Analyst? _current;

  @override
  Analyst? get currentAnalyst => _current;

  @override
  Stream<Analyst?> authStateChanges() => _changes.stream;

  @override
  Future<Analyst> signIn({
    required String email,
    required String password,
  }) async {
    final User? user;
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      user = response.user;
    } on AuthException catch (error) {
      throw _signInFailure(error);
    } catch (error) {
      throw mapToFailure(error);
    }
    if (user == null) throw const Failure.invalidCredentials();

    final analyst = _fromUser(user, fullName: await _fetchFullName(user));
    _setCurrent(analyst);
    return analyst;
  }

  /// Signs out even when the server cannot be reached: Supabase removes the stored
  /// session locally, so the analyst always gets back to the login.
  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {
      // The local session is gone anyway; nothing to show to the analyst.
    } finally {
      _setCurrent(null);
    }
  }

  /// Stops listening to Supabase. Called when the provider is disposed.
  void dispose() {
    _subscription.cancel();
    _changes.close();
  }

  /// Wrong email or password → invalid credentials (C-02); no response from the
  /// server (no status code or a 5xx) → network.
  static Failure _signInFailure(AuthException error) {
    final status = error.statusCode;
    final unreachable = status == null || status.startsWith('5');
    return unreachable
        ? const Failure.network()
        : const Failure.invalidCredentials();
  }

  void _onAuthState(AuthState state) {
    final user = state.session?.user;
    if (user == null) {
      _setCurrent(null);
    } else if (user.id != _current?.id) {
      _setCurrent(_fromUser(user));
      unawaited(_loadFullName(user));
    }
  }

  Future<void> _loadFullName(User user) async {
    final fullName = await _fetchFullName(user);
    if (_current?.id != user.id || _current?.fullName == fullName) return;
    _setCurrent(_fromUser(user, fullName: fullName));
  }

  Future<String> _fetchFullName(User user) async {
    try {
      final row = await _client
          .from('analysts')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();
      final fullName = row?['full_name'];
      if (fullName is String && fullName.trim().isNotEmpty) return fullName;
    } catch (_) {
      // The name is not essential to sign in: fall back to the metadata or email.
    }
    return _fromUser(user).fullName;
  }

  static Analyst _fromUser(User user, {String? fullName}) {
    final email = user.email ?? '';
    final metadataName = user.userMetadata?['full_name'];
    return Analyst(
      id: user.id,
      email: email,
      fullName:
          fullName ??
          (metadataName is String && metadataName.trim().isNotEmpty
              ? metadataName
              : Analyst.nameFromEmail(email)),
    );
  }

  void _setCurrent(Analyst? analyst) {
    _current = analyst;
    if (!_changes.isClosed) _changes.add(analyst);
  }
}
