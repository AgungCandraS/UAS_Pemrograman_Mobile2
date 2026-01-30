/// Environment configuration
class Env {
  Env._();

  /// Supabase configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://nccjlnguqoyjxkpstpgm.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_cwALuXelfmdFvuKC7IEtxg_YCqZi1nU',
  );

  /// App environment
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Environment checks
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';

  /// API configuration
  static const String apiTimeout = String.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: '30',
  );

  static Duration get apiTimeoutDuration =>
      Duration(seconds: int.parse(apiTimeout));
}
