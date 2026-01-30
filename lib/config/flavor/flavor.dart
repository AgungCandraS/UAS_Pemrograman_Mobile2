/// App flavor configuration
enum Flavor {
  development,
  staging,
  production;

  bool get isDevelopment => this == Flavor.development;
  bool get isStaging => this == Flavor.staging;
  bool get isProduction => this == Flavor.production;
}

/// Flavor configuration
class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String bundleId;

  const FlavorConfig({
    required this.flavor,
    required this.appName,
    required this.bundleId,
  });

  /// Development flavor
  static const development = FlavorConfig(
    flavor: Flavor.development,
    appName: 'Bisnisku Dev',
    bundleId: 'com.bisnisku.dev',
  );

  /// Staging flavor
  static const staging = FlavorConfig(
    flavor: Flavor.staging,
    appName: 'Bisnisku Staging',
    bundleId: 'com.bisnisku.staging',
  );

  /// Production flavor
  static const production = FlavorConfig(
    flavor: Flavor.production,
    appName: 'Bisnisku',
    bundleId: 'com.bisnisku',
  );
}
