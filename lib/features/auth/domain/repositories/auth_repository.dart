import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';

/// Auth repository interface
abstract class AuthRepository {
  /// Sign in with email and password
  FutureResult<UserProfile> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  FutureResult<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Sign in with Google OAuth
  FutureResult<UserProfile> signInWithGoogle();

  /// Sign out
  FutureResult<void> signOut();

  /// Get current user profile
  FutureResult<UserProfile?> getCurrentUser();

  /// Reset password
  FutureResult<void> resetPassword({required String email});

  /// Update profile
  FutureResult<UserProfile> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Check if user is authenticated
  bool isAuthenticated();
}
