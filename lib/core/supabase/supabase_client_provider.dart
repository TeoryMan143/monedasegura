import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_client_provider.g.dart';

/// The Supabase client. Only repositories (`features/*/data`) should read it.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;

/// Auth events from Supabase (initial session, sign in, sign out, token refresh).
@Riverpod(keepAlive: true)
Stream<AuthState> authState(Ref ref) =>
    ref.watch(supabaseClientProvider).auth.onAuthStateChange;

/// Whether an analyst is signed in. The router's redirect is driven by this.
@Riverpod(keepAlive: true)
bool isSignedIn(Ref ref) {
  final auth = ref.watch(authStateProvider);
  return switch (auth) {
    AsyncData(:final value) => value.session != null,
    _ => ref.watch(supabaseClientProvider).auth.currentSession != null,
  };
}
