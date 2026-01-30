import 'package:bisnisku/features/profile/domain/entities/connected_device.dart';

/// Connected device model for JSON serialization
class ConnectedDeviceModel extends ConnectedDevice {
  const ConnectedDeviceModel({
    required super.id,
    required super.userId,
    super.deviceName,
    super.deviceType,
    super.osType,
    super.osVersion,
    super.browserName,
    super.browserVersion,
    super.ipAddress,
    super.location,
    required super.lastActivity,
    super.isCurrentDevice,
  });

  factory ConnectedDeviceModel.fromJson(Map<String, dynamic> json) {
    return ConnectedDeviceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      deviceName: json['device_name'] as String?,
      deviceType: json['device_type'] as String?,
      osType: json['os_type'] as String?,
      osVersion: json['os_version'] as String?,
      browserName: json['browser_name'] as String?,
      browserVersion: json['browser_version'] as String?,
      ipAddress: json['ip_address'] as String?,
      location: json['location'] as String?,
      lastActivity: DateTime.parse(json['last_activity'] as String),
      isCurrentDevice: json['is_current_device'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'device_name': deviceName,
    'device_type': deviceType,
    'os_type': osType,
    'os_version': osVersion,
    'browser_name': browserName,
    'browser_version': browserVersion,
    'ip_address': ipAddress,
    'location': location,
    'last_activity': lastActivity.toIso8601String(),
    'is_current_device': isCurrentDevice,
  };
}
