import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The Supabase client. Only repositories (`features/*/data`) should read it.
///
/// Manual providers are kept alive by default (no `.autoDispose`), which is
/// what app-wide state wants. In prototype mode (`Env.useFakeData`) Supabase is not
/// initialised, so nothing may read this provider.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
  name: 'supabaseClientProvider',
);

/// Auth events from Supabase (initial session, sign in, sign out, token refresh).
///
/// The future `SupabaseAuthRepository` maps these to `authStateChanges()`.
final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
  name: 'authStateProvider',
);
