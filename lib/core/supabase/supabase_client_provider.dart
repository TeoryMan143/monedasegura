import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The Supabase client. Only repositories (`features/*/data`) should read it.
///
/// Manual providers are kept alive by default (no `.autoDispose`), which is
/// what app-wide state wants.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
  name: 'supabaseClientProvider',
);

/// Auth events from Supabase (initial session, sign in, sign out, token refresh).
final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
  name: 'authStateProvider',
);

/// Whether an analyst is signed in. The router's redirect is driven by this.
final isSignedInProvider = Provider<bool>((ref) {
  final auth = ref.watch(authStateProvider);
  return switch (auth) {
    AsyncData(:final value) => value.session != null,
    _ => ref.watch(supabaseClientProvider).auth.currentSession != null,
  };
}, name: 'isSignedInProvider');
