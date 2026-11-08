/// Build-time configuration passed with `--dart-define` or `--dart-define-from-file`.
///
/// Only the anon (publishable) key ever reaches the app. Never the service-role key.
abstract final class Env {
  /// Offline mode: fake repositories with in-memory data and no Supabase.
  ///
  /// Off by default: the prototype reads the real database (metodología v2) and needs
  /// `--dart-define-from-file=env.json`. Use `--dart-define=USE_FAKE_DATA=true` only to
  /// open the app without a backend.
  static const useFakeData = bool.fromEnvironment('USE_FAKE_DATA');

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Test mode of HU-16: the simulated realtime connection drops every minute for a few
  /// seconds so the top bar shows «Reconectando…». Run with
  /// `--dart-define=SIMULATE_RECONNECT=true`.
  static const simulateReconnect = bool.fromEnvironment('SIMULATE_RECONNECT');

  /// Demo mode: the first read of each alert and statistic fails and the next works, to
  /// show the error state and «Reintentar». Run with `--dart-define=DEMO_FAIL_ONCE=true`.
  static const demoFailOnce = bool.fromEnvironment('DEMO_FAIL_ONCE');

  /// Names of the required values that were not provided at build time.
  static List<String> get missingKeys => [
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
  ];
}
