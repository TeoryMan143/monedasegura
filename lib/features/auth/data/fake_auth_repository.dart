import 'dart:async';

import '../../../core/errors/failure.dart';
import '../domain/analyst.dart';
import 'auth_repository.dart';

/// In-memory [AuthRepository] for the prototype (no Supabase).
///
/// Any email and password sign in, after a short delay so the button shows its loading
/// state. Demo cases:
///
/// | Email | Result |
/// | --- | --- |
/// | [invalidCredentialsEmail] | C-02 · `Failure.invalidCredentials` |
/// | [networkErrorEmail] | `Failure.network` («Sin conexión») |
///
/// The session lives in memory: closing the app signs out.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    Analyst? initialAnalyst,
    this.delay = const Duration(milliseconds: 600),
  }) : _current = initialAnalyst;

  /// Shows the invalid credentials message (C-02).
  static const invalidCredentialsEmail = 'error@monedasegura.co';

  /// Simulates a network failure on sign in.
  static const networkErrorEmail = 'sinred@monedasegura.co';

  /// Simulated latency of every call.
  final Duration delay;

  final _changes = StreamController<Analyst?>.broadcast();
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
    await Future<void>.delayed(delay);
    final normalized = email.trim().toLowerCase();
    if (normalized == invalidCredentialsEmail || password.isEmpty) {
      throw const Failure.invalidCredentials();
    }
    if (normalized == networkErrorEmail) throw const Failure.network();

    final analyst = Analyst(
      id: 'analyst-${normalized.hashCode.toUnsigned(32)}',
      email: normalized,
      fullName: nameFromEmail(normalized),
    );
    _setCurrent(analyst);
    return analyst;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(delay ~/ 3);
    _setCurrent(null);
  }

  void _setCurrent(Analyst? analyst) {
    _current = analyst;
    if (!_changes.isClosed) _changes.add(analyst);
  }

  /// Closes the stream. Called when the provider is disposed.
  void dispose() => _changes.close();

  /// «laura.gomez@monedasegura.co» → «Laura Gomez». Falls back to «Analista».
  static String nameFromEmail(String email) {
    final local = email.split('@').first;
    final words = local
        .split(RegExp('[._-]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .toList();
    return words.isEmpty ? 'Analista' : words.join(' ');
  }
}
