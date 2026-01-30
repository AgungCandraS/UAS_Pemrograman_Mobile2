import 'package:bisnisku/features/profile/domain/entities/profile_settings.dart';

/// Profile settings model
class ProfileSettingsModel extends ProfileSettings {
  const ProfileSettingsModel({
    required super.userId,
    super.notificationsEnabled,
    super.emailNotifications,
    super.pushNotifications,
    super.language,
    super.theme,
    super.currency,
    super.dateFormat,
    super.timeFormat,
    super.updatedAt,
  });

  factory ProfileSettingsModel.fromJson(Map<String, dynamic> json) {
    return ProfileSettingsModel(
      userId: json['user_id'] as String,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'id',
      theme: json['theme'] as String? ?? 'system',
      currency: json['currency'] as String? ?? 'IDR',
      dateFormat: json['date_format'] as String? ?? 'dd/MM/yyyy',
      timeFormat: json['time_format'] as String? ?? '24h',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'notifications_enabled': notificationsEnabled,
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'language': language,
      'theme': theme,
      'currency': currency,
      'date_format': dateFormat,
      'time_format': timeFormat,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  ProfileSettingsModel copyWith({
    String? userId,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    String? language,
    String? theme,
    String? currency,
    String? dateFormat,
    String? timeFormat,
    DateTime? updatedAt,
  }) {
    return ProfileSettingsModel(
      userId: userId ?? this.userId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
