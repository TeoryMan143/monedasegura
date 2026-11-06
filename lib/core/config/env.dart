/// Build-time configuration passed with `--dart-define` or `--dart-define-from-file`.
///
/// Only the anon (publishable) key ever reaches the app. Never the service-role key.
abstract final class Env {
  /// Prototype mode: fake repositories with in-memory data, no Supabase.
  ///
  /// On by default until the functional version (S4). Run with
  /// `--dart-define=USE_FAKE_DATA=false` plus the Supabase keys to use the backend.
  static const useFakeData = bool.fromEnvironment(
    'USE_FAKE_DATA',
    defaultValue: true,
  );

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Test mode of HU-16: the simulated realtime connection drops every minute for a few
  /// seconds so the top bar shows «Reconectando…». Run with
  /// `--dart-define=SIMULATE_RECONNECT=true`.
  static const simulateReconnect = bool.fromEnvironment('SIMULATE_RECONNECT');

  /// Names of the required values that were not provided at build time.
  static List<String> get missingKeys => [
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
  ];
}
