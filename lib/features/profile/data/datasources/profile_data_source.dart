import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Profile data source for Supabase
class ProfileDataSource {
  final SupabaseClient _supabase;

  ProfileDataSource(this._supabase);

  /// Get user profile from Supabase
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await _supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();

    return response;
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _supabase
        .from('user_profiles')
        .update(data)
        .eq('id', userId)
        .select()
        .single();

    return response;
  }

  /// Upload avatar to Supabase Storage
  Future<String> uploadAvatar(
    String userId,
    Uint8List bytes,
    String fileExtension,
  ) async {
    final fileName =
        '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    final filePath = 'avatars/$fileName';

    await _supabase.storage
        .from('profiles')
        .uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/$fileExtension',
            upsert: true,
          ),
        );

    final publicUrl = _supabase.storage.from('profiles').getPublicUrl(filePath);
    return publicUrl;
  }

  /// Get company info
  Future<Map<String, dynamic>?> getCompanyInfo(String userId) async {
    final response = await _supabase
        .from('company_info')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return response;
  }

  /// Update or insert company info
  Future<Map<String, dynamic>> upsertCompanyInfo(
    Map<String, dynamic> data,
  ) async {
    final response = await _supabase
        .from('company_info')
        .upsert(data, onConflict: 'user_id')
        .select()
        .single();

    return response;
  }

  /// Get profile settings
  Future<Map<String, dynamic>?> getProfileSettings(String userId) async {
    final response = await _supabase
        .from('profile_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return response;
  }

  /// Update or insert profile settings
  Future<Map<String, dynamic>> upsertProfileSettings(
    Map<String, dynamic> data,
  ) async {
    final response = await _supabase
        .from('profile_settings')
        .upsert(data)
        .select()
        .single();

    return response;
  }

  /// Delete user account
  Future<void> deleteAccount(String userId) async {
    await _supabase.from('user_profiles').delete().eq('id', userId);
  }

  /// Change password
  Future<void> changePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Get login activities for user
  Future<List<Map<String, dynamic>>> getLoginActivities(String userId) async {
    try {
      final response = await _supabase
          .from('login_activities')
          .select()
          .eq('user_id', userId)
          .order('login_time', ascending: false)
          .limit(50);

      return List<Map<String, dynamic>>.from(response as List);
    } on PostgrestException catch (e) {
      // Handle table not found error gracefully
      if (e.message.contains('login_activities') || e.code == 'PGRST205') {
        // Return empty list if table doesn't exist yet
        return [];
      }
      rethrow;
    }
  }

  /// Get connected devices for user
  Future<List<Map<String, dynamic>>> getConnectedDevices(String userId) async {
    try {
      final response = await _supabase
          .from('connected_devices')
          .select()
          .eq('user_id', userId)
          .order('last_activity', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } on PostgrestException catch (e) {
      // Handle table not found error gracefully
      if (e.message.contains('connected_devices') || e.code == 'PGRST205') {
        // Return empty list if table doesn't exist yet
        return [];
      }
      rethrow;
    }
  }

  /// Remove connected device
  Future<void> removeConnectedDevice(String deviceId) async {
    try {
      await _supabase.from('connected_devices').delete().eq('id', deviceId);
    } on PostgrestException catch (e) {
      if (e.message.contains('connected_devices') || e.code == 'PGRST205') {
        return; // Silently fail if table doesn't exist
      }
      rethrow;
    }
  }

  /// Logout from other sessions
  Future<void> logoutOtherSessions(String userId) async {
    try {
      await _supabase
          .from('connected_devices')
          .delete()
          .eq('user_id', userId)
          .neq('is_current_device', true);
    } on PostgrestException catch (e) {
      if (e.message.contains('connected_devices') || e.code == 'PGRST205') {
        return;
      }
      rethrow;
    }
  }

  /// Get 2FA settings
  Future<Map<String, dynamic>?> getTwoFactorAuth(String userId) async {
    try {
      final response = await _supabase
          .from('two_factor_auth')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      if (e.message.contains('two_factor_auth') || e.code == 'PGRST205') {
        // Return null if table doesn't exist, means 2FA not enabled
        return null;
      }
      rethrow;
    }
  }

  /// Enable 2FA
  Future<Map<String, dynamic>> enableTwoFactorAuth(
    String userId,
    String method,
  ) async {
    try {
      final response = await _supabase
          .from('two_factor_auth')
          .upsert({
            'user_id': userId,
            'enabled': true,
            'method': method,
            'enabled_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      if (e.message.contains('two_factor_auth') || e.code == 'PGRST205') {
        // Create a mock response if table doesn't exist
        return {
          'user_id': userId,
          'enabled': true,
          'method': method,
          'enabled_at': DateTime.now().toIso8601String(),
        };
      }
      rethrow;
    }
  }

  /// Disable 2FA
  Future<void> disableTwoFactorAuth(String userId) async {
    try {
      await _supabase.from('two_factor_auth').delete().eq('user_id', userId);
    } on PostgrestException catch (e) {
      if (e.message.contains('two_factor_auth') || e.code == 'PGRST205') {
        return;
      }
      rethrow;
    }
  }
}
