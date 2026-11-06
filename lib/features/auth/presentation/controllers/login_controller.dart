import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

/// State of the C-01 login form: idle (`AsyncData`), signing in (`AsyncLoading`) or the
/// `Failure` of the last attempt (`AsyncError`, shown as the C-02 banner).
final loginControllerProvider =
    AsyncNotifierProvider.autoDispose<LoginController, void>(
      LoginController.new,
      name: 'loginControllerProvider',
    );

/// Signs in with email and password (HU-01).
///
/// On success the session provider changes and the router leaves the login, which
/// disposes this controller, so it never navigates by itself.
class LoginController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard<void>(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email.trim(), password: password),
    );
    if (!ref.mounted) return;
    state = result;
  }

  /// Hides the error banner when the analyst edits the form again.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
