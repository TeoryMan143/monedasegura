/// Build-time configuration passed with `--dart-define` or `--dart-define-from-file`.
///
/// Only the anon (publishable) key ever reaches the app. Never the service-role key.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Names of the required values that were not provided at build time.
  static List<String> get missingKeys => [
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
  ];
}
