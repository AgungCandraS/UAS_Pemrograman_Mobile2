import 'package:equatable/equatable.dart';

/// Profile settings entity
class ProfileSettings extends Equatable {
  final String userId;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final String currency;
  final String dateFormat;
  final String timeFormat;
  final DateTime? updatedAt;

  const ProfileSettings({
    required this.userId,
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.language = 'id',
    this.theme = 'system',
    this.currency = 'IDR',
    this.dateFormat = 'dd/MM/yyyy',
    this.timeFormat = '24h',
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    notificationsEnabled,
    emailNotifications,
    pushNotifications,
    language,
    theme,
    currency,
    dateFormat,
    timeFormat,
    updatedAt,
  ];

  ProfileSettings copyWith({
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
    return ProfileSettings(
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
