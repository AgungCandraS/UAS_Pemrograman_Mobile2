import 'dart:typed_data';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/profile/domain/entities/company_info.dart';
import 'package:bisnisku/features/profile/domain/entities/profile_settings.dart';
import 'package:bisnisku/features/profile/domain/entities/login_activity.dart';
import 'package:bisnisku/features/profile/domain/entities/connected_device.dart';
import 'package:bisnisku/features/profile/domain/entities/two_factor_auth.dart';

/// Profile repository interface
abstract class ProfileRepository {
  /// Get user profile by ID
  Future<UserProfile> getUserProfile(String userId);

  /// Update user profile
  Future<UserProfile> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? companyName,
    String? avatarUrl,
  });

  /// Upload avatar image
  Future<String> uploadAvatar(
    String userId,
    Uint8List bytes,
    String fileExtension,
  );

  /// Get company info
  Future<CompanyInfo?> getCompanyInfo(String userId);

  /// Update company info
  Future<CompanyInfo> updateCompanyInfo(CompanyInfo companyInfo);

  /// Get profile settings
  Future<ProfileSettings?> getProfileSettings(String userId);

  /// Update profile settings
  Future<ProfileSettings> updateProfileSettings(ProfileSettings settings);

  /// Delete user account
  Future<void> deleteAccount(String userId);

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Get login activities
  Future<List<LoginActivity>> getLoginActivities(String userId);

  /// Get connected devices
  Future<List<ConnectedDevice>> getConnectedDevices(String userId);

  /// Remove connected device
  Future<void> removeConnectedDevice(String deviceId);

  /// Logout from other sessions
  Future<void> logoutOtherSessions(String userId);

  /// Get 2FA settings
  Future<TwoFactorAuth?> getTwoFactorAuth(String userId);

  /// Enable 2FA
  Future<TwoFactorAuth> enableTwoFactorAuth(String userId, String method);

  /// Disable 2FA
  Future<void> disableTwoFactorAuth(String userId);
}
