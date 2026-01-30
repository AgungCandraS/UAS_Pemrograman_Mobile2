import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bisnisku/core/errors/exceptions.dart' as app_exceptions;
import 'package:bisnisku/features/auth/data/models/user_profile_model.dart';

/// Auth remote data source
abstract class AuthRemoteDataSource {
  Future<UserProfileModel> signIn({
    required String email,
    required String password,
  });

  Future<UserProfileModel> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Sign in with Google OAuth
  Future<UserProfileModel> signInWithGoogle();

  Future<void> signOut();

  Future<UserProfileModel?> getCurrentUser();

  Future<void> resetPassword({required String email});

  Future<UserProfileModel> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  });
}

/// Auth remote data source implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserProfileModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const app_exceptions.AuthException(message: 'Login gagal');
      }

      // Ensure profile exists, create if missing
      return await _getOrCreateUserProfile(
        userId: response.user!.id,
        email: response.user!.email ?? email,
        fullName: response.user!.userMetadata?['full_name'] as String?,
      );
    } on AuthApiException catch (e) {
      throw app_exceptions.AuthException(message: e.message);
    } catch (e) {
      throw app_exceptions.AuthException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw const app_exceptions.AuthException(message: 'Registrasi gagal');
      }

      // Create user profile in public.users table
      final profileData = {
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _client.from('users').insert(profileData);

      return UserProfileModel.fromJson({...profileData, 'updated_at': null});
    } on AuthApiException catch (e) {
      throw app_exceptions.AuthException(message: e.message);
    } catch (e) {
      throw app_exceptions.AuthException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> signInWithGoogle() async {
    try {
      // Sign in with Google OAuth - opens native auth flow
      await _client.auth.signInWithOAuth(OAuthProvider.google);

      // Get the current user after OAuth completes
      final user = _client.auth.currentUser;

      if (user == null || user.id.isEmpty) {
        throw const app_exceptions.AuthException(
          message: 'Login Google gagal: user tidak ditemukan',
        );
      }

      return await _getOrCreateUserProfile(
        userId: user.id,
        email: user.email ?? 'noemail@google.com',
        fullName: user.userMetadata?['full_name'] as String?,
      );
    } on AuthApiException catch (e) {
      throw app_exceptions.AuthException(message: e.message);
    } catch (e) {
      throw app_exceptions.AuthException(
        message: 'Google login error: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw app_exceptions.AuthException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      return await _getOrCreateUserProfile(
        userId: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
      throw app_exceptions.AuthException(message: e.message);
    } catch (e) {
      throw app_exceptions.AuthException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (phoneNumber != null) updates['phone'] = phoneNumber;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _client.from('users').update(updates).eq('id', userId);

      return await _getUserProfile(userId);
    } catch (e) {
      throw app_exceptions.ServerException(message: e.toString());
    }
  }

  Future<UserProfileModel> _getUserProfile(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      throw app_exceptions.NotFoundException(message: 'Profil tidak ditemukan');
    }

    return UserProfileModel.fromJson(response);
  }

  /// Get profile, auto-create if missing
  Future<UserProfileModel> _getOrCreateUserProfile({
    required String userId,
    required String email,
    String? fullName,
  }) async {
    try {
      return await _getUserProfile(userId);
    } on app_exceptions.NotFoundException {
      final profileData = {
        'id': userId,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': null,
      };

      await _client.from('users').upsert(profileData);
      return UserProfileModel.fromJson(profileData);
    }
  }
}
