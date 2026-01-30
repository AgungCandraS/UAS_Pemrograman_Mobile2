import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/constants/supabase_constants.dart';

/// Supabase service for managing database and auth operations
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      anonKey: SupabaseConstants.supabaseAnonKey,
    );
  }

  /// Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  /// Get Auth client
  GoTrueClient get auth => client.auth;

  /// Get Storage client
  SupabaseStorageClient get storage => client.storage;

  /// Get current user
  User? get currentUser => auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}

