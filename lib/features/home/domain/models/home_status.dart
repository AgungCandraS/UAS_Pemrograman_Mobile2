import 'package:equatable/equatable.dart';

/// Model untuk status stok inventori
class InventoryStatus extends Equatable {
  const InventoryStatus({
    required this.stokAman,
    required this.menipis,
    required this.habis,
  });

  final int stokAman;
  final int menipis;
  final int habis;

  factory InventoryStatus.fromJson(Map<String, dynamic> json) {
    return InventoryStatus(
      stokAman: json['stok_aman'] as int? ?? 0,
      menipis: json['menipis'] as int? ?? 0,
      habis: json['habis'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'stok_aman': stokAman, 'menipis': menipis, 'habis': habis};
  }

  @override
  List<Object?> get props => [stokAman, menipis, habis];
}

/// Model untuk aktivitas terbaru
class RecentActivity extends Equatable {
  const RecentActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.icon,
    this.metadata,
  });

  final String id;
  final ActivityType type;
  final String description;
  final DateTime timestamp;
  final String? icon;
  final Map<String, dynamic>? metadata;

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] as String,
      type: ActivityType.fromString(json['type'] as String),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      icon: json['icon'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'icon': icon,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [id, type, description, timestamp, icon, metadata];
}

/// Enum untuk jenis aktivitas
enum ActivityType {
  inventory('inventory'),
  order('order'),
  payment('payment'),
  employee('employee'),
  production('production'),
  other('other');

  const ActivityType(this.value);
  final String value;

  static ActivityType fromString(String value) {
    return ActivityType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ActivityType.other,
    );
  }
}

/// Model untuk weather info
class WeatherInfo extends Equatable {
  const WeatherInfo({
    required this.temperature,
    required this.condition,
    required this.location,
  });

  final double temperature;
  final String condition;
  final String location;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'condition': condition,
      'location': location,
    };
  }

  @override
  List<Object?> get props => [temperature, condition, location];
}
