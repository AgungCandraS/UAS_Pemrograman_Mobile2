import 'dart:typed_data';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/auth/data/models/user_profile_model.dart';
import 'package:bisnisku/features/profile/data/datasources/profile_data_source.dart';
import 'package:bisnisku/features/profile/data/models/company_info_model.dart';
import 'package:bisnisku/features/profile/data/models/profile_settings_model.dart';
import 'package:bisnisku/features/profile/data/models/login_activity_model.dart';
import 'package:bisnisku/features/profile/data/models/connected_device_model.dart';
import 'package:bisnisku/features/profile/data/models/two_factor_auth_model.dart';
import 'package:bisnisku/features/profile/domain/entities/company_info.dart';
import 'package:bisnisku/features/profile/domain/entities/profile_settings.dart';
import 'package:bisnisku/features/profile/domain/entities/login_activity.dart';
import 'package:bisnisku/features/profile/domain/entities/connected_device.dart';
import 'package:bisnisku/features/profile/domain/entities/two_factor_auth.dart';
import 'package:bisnisku/features/profile/domain/repositories/profile_repository.dart';

/// Profile repository implementation
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final data = await _dataSource.getUserProfile(userId);
      return UserProfileModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfile> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? companyName,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        if (fullName != null) 'full_name': fullName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (companyName != null) 'company_name': companyName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _dataSource.updateUserProfile(userId, data);
      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<String> uploadAvatar(
    String userId,
    Uint8List bytes,
    String fileExtension,
  ) async {
    try {
      return await _dataSource.uploadAvatar(userId, bytes, fileExtension);
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  @override
  Future<CompanyInfo?> getCompanyInfo(String userId) async {
    try {
      final data = await _dataSource.getCompanyInfo(userId);
      if (data == null) return null;
      return CompanyInfoModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get company info: $e');
    }
  }

  @override
  Future<CompanyInfo> updateCompanyInfo(CompanyInfo companyInfo) async {
    try {
      final model = CompanyInfoModel(
        userId: companyInfo.userId,
        legalName: companyInfo.legalName,
        taxId: companyInfo.taxId,
        businessType: companyInfo.businessType,
        industry: companyInfo.industry,
        address: companyInfo.address,
        city: companyInfo.city,
        province: companyInfo.province,
        postalCode: companyInfo.postalCode,
        country: companyInfo.country,
        website: companyInfo.website,
        description: companyInfo.description,
        establishedDate: companyInfo.establishedDate,
        updatedAt: DateTime.now(),
      );

      final response = await _dataSource.upsertCompanyInfo(model.toJson());
      return CompanyInfoModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update company info: $e');
    }
  }

  @override
  Future<ProfileSettings?> getProfileSettings(String userId) async {
    try {
      final data = await _dataSource.getProfileSettings(userId);
      if (data == null) return null;
      return ProfileSettingsModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get profile settings: $e');
    }
  }

  @override
  Future<ProfileSettings> updateProfileSettings(
    ProfileSettings settings,
  ) async {
    try {
      final model = ProfileSettingsModel(
        userId: settings.userId,
        notificationsEnabled: settings.notificationsEnabled,
        emailNotifications: settings.emailNotifications,
        pushNotifications: settings.pushNotifications,
        language: settings.language,
        theme: settings.theme,
        currency: settings.currency,
        dateFormat: settings.dateFormat,
        timeFormat: settings.timeFormat,
        updatedAt: DateTime.now(),
      );

      final response = await _dataSource.upsertProfileSettings(model.toJson());
      return ProfileSettingsModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile settings: $e');
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      await _dataSource.deleteAccount(userId);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.changePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<List<LoginActivity>> getLoginActivities(String userId) async {
    try {
      final data = await _dataSource.getLoginActivities(userId);
      return data.map((e) => LoginActivityModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to get login activities: $e');
    }
  }

  @override
  Future<List<ConnectedDevice>> getConnectedDevices(String userId) async {
    try {
      final data = await _dataSource.getConnectedDevices(userId);
      return data.map((e) => ConnectedDeviceModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to get connected devices: $e');
    }
  }

  @override
  Future<void> removeConnectedDevice(String deviceId) async {
    try {
      await _dataSource.removeConnectedDevice(deviceId);
    } catch (e) {
      throw Exception('Failed to remove device: $e');
    }
  }

  @override
  Future<void> logoutOtherSessions(String userId) async {
    try {
      await _dataSource.logoutOtherSessions(userId);
    } catch (e) {
      throw Exception('Failed to logout other sessions: $e');
    }
  }

  @override
  Future<TwoFactorAuth?> getTwoFactorAuth(String userId) async {
    try {
      final data = await _dataSource.getTwoFactorAuth(userId);
      if (data == null) return null;
      return TwoFactorAuthModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get 2FA settings: $e');
    }
  }

  @override
  Future<TwoFactorAuth> enableTwoFactorAuth(
    String userId,
    String method,
  ) async {
    try {
      final data = await _dataSource.enableTwoFactorAuth(userId, method);
      return TwoFactorAuthModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to enable 2FA: $e');
    }
  }

  @override
  Future<void> disableTwoFactorAuth(String userId) async {
    try {
      await _dataSource.disableTwoFactorAuth(userId);
    } catch (e) {
      throw Exception('Failed to disable 2FA: $e');
    }
  }
}
