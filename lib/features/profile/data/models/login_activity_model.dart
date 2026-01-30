import 'package:bisnisku/features/profile/domain/entities/login_activity.dart';

/// Login activity model for JSON serialization
class LoginActivityModel extends LoginActivity {
  const LoginActivityModel({
    required super.id,
    required super.userId,
    required super.loginTime,
    super.deviceName,
    super.deviceType,
    super.osType,
    super.osVersion,
    super.browserName,
    super.browserVersion,
    super.ipAddress,
    super.location,
    super.isCurrentSession,
  });

  factory LoginActivityModel.fromJson(Map<String, dynamic> json) {
    return LoginActivityModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      loginTime: DateTime.parse(json['login_time'] as String),
      deviceName: json['device_name'] as String?,
      deviceType: json['device_type'] as String?,
      osType: json['os_type'] as String?,
      osVersion: json['os_version'] as String?,
      browserName: json['browser_name'] as String?,
      browserVersion: json['browser_version'] as String?,
      ipAddress: json['ip_address'] as String?,
      location: json['location'] as String?,
      isCurrentSession: json['is_current_session'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'login_time': loginTime.toIso8601String(),
    'device_name': deviceName,
    'device_type': deviceType,
    'os_type': osType,
    'os_version': osVersion,
    'browser_name': browserName,
    'browser_version': browserVersion,
    'ip_address': ipAddress,
    'location': location,
    'is_current_session': isCurrentSession,
  };
}
