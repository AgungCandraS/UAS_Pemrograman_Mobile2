import 'dart:typed_data';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/profile/data/datasources/profile_data_source.dart';
import 'package:bisnisku/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:bisnisku/features/profile/domain/entities/company_info.dart';
import 'package:bisnisku/features/profile/domain/entities/profile_settings.dart';
import 'package:bisnisku/features/profile/domain/entities/login_activity.dart';
import 'package:bisnisku/features/profile/domain/entities/connected_device.dart';
import 'package:bisnisku/features/profile/domain/entities/two_factor_auth.dart';
import 'package:bisnisku/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth state stream provider - tracks Supabase auth state changes
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

/// Current user ID provider
final currentUserIdProvider = Provider<String?>((ref) {
  // Watch auth state to auto-refresh when user logs in/out
  ref.watch(authStateStreamProvider);
  return Supabase.instance.client.auth.currentUser?.id;
});

/// Profile data source provider
final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  return ProfileDataSource(Supabase.instance.client);
});

/// Profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
});

/// Current user profile provider
final currentUserProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  return repository.getUserProfile(userId);
});

/// Company info provider
final companyInfoProvider = FutureProvider<CompanyInfo?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  return repository.getCompanyInfo(userId);
});

/// Profile settings provider
final profileSettingsProvider = FutureProvider<ProfileSettings?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  return repository.getProfileSettings(userId);
});

/// Immediate theme notifier - for instant theme changes
class ImmediateThemeNotifier extends StateNotifier<String> {
  ImmediateThemeNotifier() : super('system');

  // Track if user has manually set a theme (not from database)
  bool _userHasSetTheme = false;

  void setTheme(String theme) {
    state = theme;
    _userHasSetTheme = true;
  }

  void resetToDefault() {
    state = 'system';
    _userHasSetTheme = false;
  }

  void loadFromDatabase(String theme) {
    // Only load from database if user hasn't manually set theme
    if (!_userHasSetTheme) {
      state = theme;
    }
  }
}

/// Immediate theme provider - updates instantly
/// This is the source of truth for UI theme, persisted to database separately
final immediateThemeProvider =
    StateNotifierProvider<ImmediateThemeNotifier, String>((ref) {
      final notifier = ImmediateThemeNotifier();

      // On app startup, load theme from database and set it
      ref.listen(
        profileSettingsProvider.select(
          (settingsAsync) =>
              settingsAsync.whenData((settings) => settings?.theme ?? 'system'),
        ),
        (previous, next) {
          // Only load from database if user hasn't manually changed theme
          // Use the new loadFromDatabase method instead of setTheme
          if (next.hasValue) {
            notifier.loadFromDatabase(next.value ?? 'system');
          }
        },
      );

      return notifier;
    });

/// Update profile state notifier
class UpdateProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  UpdateProfileNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? companyName,
    String? avatarUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateUserProfile(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        companyName: companyName,
        avatarUrl: avatarUrl,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<String> uploadAvatar(
    String userId,
    Uint8List bytes,
    String fileExtension,
  ) async {
    return await _repository.uploadAvatar(userId, bytes, fileExtension);
  }
}

/// Update profile provider
final updateProfileProvider =
    StateNotifierProvider<UpdateProfileNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return UpdateProfileNotifier(repository);
    });

/// Update company info state notifier
class UpdateCompanyInfoNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  UpdateCompanyInfoNotifier(this._repository)
    : super(const AsyncValue.data(null));

  Future<void> updateCompanyInfo(CompanyInfo companyInfo) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateCompanyInfo(companyInfo);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Update company info provider
final updateCompanyInfoProvider =
    StateNotifierProvider<UpdateCompanyInfoNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return UpdateCompanyInfoNotifier(repository);
    });

/// Update settings state notifier
class UpdateSettingsNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  UpdateSettingsNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateSettings(ProfileSettings settings) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfileSettings(settings);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Update settings provider
final updateSettingsProvider =
    StateNotifierProvider<UpdateSettingsNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return UpdateSettingsNotifier(repository);
    });

/// Login activities provider
final loginActivitiesProvider = FutureProvider<List<LoginActivity>>((
  ref,
) async {
  final repository = ref.watch(profileRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  return repository.getLoginActivities(userId);
});

/// Connected devices provider
final connectedDevicesProvider = FutureProvider<List<ConnectedDevice>>((
  ref,
) async {
  final repository = ref.watch(profileRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  return repository.getConnectedDevices(userId);
});

/// Two-Factor Auth provider
final twoFactorAuthProvider = FutureProvider<TwoFactorAuth?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  return repository.getTwoFactorAuth(userId);
});

/// Two-Factor Auth notifier
class TwoFactorAuthNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  TwoFactorAuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> enableTwoFactor(String userId, String method) async {
    state = const AsyncValue.loading();
    try {
      await _repository.enableTwoFactorAuth(userId, method);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> disableTwoFactor(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.disableTwoFactorAuth(userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Two-Factor Auth notifier provider
final twoFactorAuthNotifierProvider =
    StateNotifierProvider<TwoFactorAuthNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return TwoFactorAuthNotifier(repository);
    });

/// Connected device management notifier
class ConnectedDeviceNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  ConnectedDeviceNotifier(this._repository)
    : super(const AsyncValue.data(null));

  Future<void> removeDevice(String deviceId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeConnectedDevice(deviceId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logoutOtherSessions(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.logoutOtherSessions(userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Connected device notifier provider
final connectedDeviceNotifierProvider =
    StateNotifierProvider<ConnectedDeviceNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return ConnectedDeviceNotifier(repository);
    });
