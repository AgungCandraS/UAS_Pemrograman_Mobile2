import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'supabase_service.dart';

/// Authentication service using Supabase
class AuthService {
  final _supabase = SupabaseService.instance;
  final _logger = Logger();

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _logger.i('User signed in: ${response.user?.email}');
      return response;
    } catch (e) {
      _logger.e('Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      _logger.i('User signed up: ${response.user?.email}');
      return response;
    } catch (e) {
      _logger.e('Sign up error: $e');
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      _logger.i('Password reset email sent to: $email');
    } catch (e) {
      _logger.e('Reset password error: $e');
      rethrow;
    }
  }

  /// Update password
  Future<UserResponse> updatePassword({required String newPassword}) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _logger.i('Password updated successfully');
      return response;
    } catch (e) {
      _logger.e('Update password error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.signOut();
      _logger.i('User signed out');
    } catch (e) {
      _logger.e('Sign out error: $e');
      rethrow;
    }
  }

  /// Get current user
  User? get currentUser => _supabase.currentUser;

  /// Check if authenticated
  bool get isAuthenticated => _supabase.isAuthenticated;

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      _logger.e('Get user profile error: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.client.from('users').update(data).eq('id', userId);

      _logger.i('User profile updated');
    } catch (e) {
      _logger.e('Update user profile error: $e');
      rethrow;
    }
  }
}

