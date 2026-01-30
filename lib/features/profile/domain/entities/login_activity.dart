import 'package:equatable/equatable.dart';

/// Login activity entity
class LoginActivity extends Equatable {
  final String id;
  final String userId;
  final DateTime loginTime;
  final String? deviceName;
  final String? deviceType; // mobile, web, desktop
  final String? osType; // iOS, Android, Windows, macOS, Linux
  final String? osVersion;
  final String? browserName;
  final String? browserVersion;
  final String? ipAddress;
  final String? location;
  final bool isCurrentSession;

  const LoginActivity({
    required this.id,
    required this.userId,
    required this.loginTime,
    this.deviceName,
    this.deviceType,
    this.osType,
    this.osVersion,
    this.browserName,
    this.browserVersion,
    this.ipAddress,
    this.location,
    this.isCurrentSession = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    loginTime,
    deviceName,
    deviceType,
    osType,
    osVersion,
    browserName,
    browserVersion,
    ipAddress,
    location,
    isCurrentSession,
  ];
}
