/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// App information
  static const String appName = 'Bisnisku';
  static const String appVersion = '1.0.0';

  /// API constants
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  /// Cache constants
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Date formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  /// Currency
  static const String currencySymbol = 'Rp';
  static const String currencyCode = 'IDR';

  /// Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Debounce durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration inputDebounce = Duration(milliseconds: 300);
}
