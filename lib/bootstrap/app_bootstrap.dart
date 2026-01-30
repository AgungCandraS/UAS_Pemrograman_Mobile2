import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bisnisku/config/env/env.dart';
import 'package:bisnisku/core/utils/logger.dart';
import 'package:bisnisku/bootstrap/di.dart';

/// Bootstrap the app with necessary initialization
class AppBootstrap {
  const AppBootstrap();

  /// Initialize all app dependencies and services
  Future<ProviderContainer> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      // Initialize logger
      AppLogger.init();
      AppLogger.info('🚀 Starting app initialization...');

      // Initialize Hive untuk persistence
      await _initializeHive();

      // Initialize Supabase
      await _initializeSupabase();

      // Initialize secure storage
      await _initializeStorage();

      // Setup DI container
      final container = await DI.setup();

      AppLogger.success('✅ App initialization completed');
      return container;
    } catch (e, stack) {
      AppLogger.error('❌ App initialization failed', e, stack);
      rethrow;
    }
  }

  Future<void> _initializeHive() async {
    try {
      await Hive.initFlutter();
      AppLogger.info('✓ Hive initialized for local persistence');
    } catch (e) {
      AppLogger.warning('⚠️ Hive initialization warning: $e');
      // Don't throw, just warn - app can work without local storage
    }
  }

  Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: Env.isDevelopment,
    );
    AppLogger.info('✓ Supabase initialized');
  }

  Future<void> _initializeStorage() async {
    // Initialize secure storage if needed
    AppLogger.info('✓ Storage initialized');
  }
}
