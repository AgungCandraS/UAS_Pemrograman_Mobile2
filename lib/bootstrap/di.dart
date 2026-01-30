import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/core/network/supabase_client.dart';

/// Dependency Injection container setup
class DI {
  DI._();

  /// Setup and return the provider container
  static Future<ProviderContainer> setup() async {
    final container = ProviderContainer(overrides: []);

    // Register core dependencies
    _registerCore(container);

    // Register feature dependencies
    _registerFeatures(container);

    return container;
  }

  static void _registerCore(ProviderContainer container) {
    // Supabase client is already provided via supabaseClientProvider
    container.read(supabaseClientProvider);
  }

  static void _registerFeatures(ProviderContainer container) {
    // Feature providers are registered via their respective provider files
    // Auth providers
    // Orders providers
    // etc.
  }
}
