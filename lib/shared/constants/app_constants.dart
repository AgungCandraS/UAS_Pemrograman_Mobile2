/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Bisnisku';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Splash screen duration
  static const Duration splashDuration = Duration(seconds: 3);

  // Session timeout
  static const Duration sessionTimeout = Duration(hours: 24);

  // Pagination
  static const int itemsPerPage = 20;

  // Image constraints
  static const int maxImageSizeMB = 5;
  static const double maxImageWidth = 1920;
  static const double maxImageHeight = 1080;

  // Input validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
}
