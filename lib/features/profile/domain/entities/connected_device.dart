import 'package:equatable/equatable.dart';

/// Connected device entity
class ConnectedDevice extends Equatable {
  final String id;
  final String userId;
  final String? deviceName;
  final String? deviceType; // mobile, web, desktop
  final String? osType; // iOS, Android, Windows, macOS, Linux
  final String? osVersion;
  final String? browserName;
  final String? browserVersion;
  final String? ipAddress;
  final String? location;
  final DateTime lastActivity;
  final bool isCurrentDevice;

  const ConnectedDevice({
    required this.id,
    required this.userId,
    this.deviceName,
    this.deviceType,
    this.osType,
    this.osVersion,
    this.browserName,
    this.browserVersion,
    this.ipAddress,
    this.location,
    required this.lastActivity,
    this.isCurrentDevice = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    deviceName,
    deviceType,
    osType,
    osVersion,
    browserName,
    browserVersion,
    ipAddress,
    location,
    lastActivity,
    isCurrentDevice,
  ];
}
