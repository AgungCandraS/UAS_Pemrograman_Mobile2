import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';

/// User profile model
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    super.fullName,
    super.avatarUrl,
    super.companyName,
    super.phoneNumber,
    super.role,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON
  factory UserProfileModel.fromJson(Json json) {
    DateTime parseDate(dynamic value, {DateTime? fallback}) {
      if (value == null) return fallback ?? DateTime.now();
      if (value is DateTime) return value;
      return DateTime.parse(value.toString());
    }

    final idValue = json['id'] ?? json['user_id'];
    final emailValue = json['email'] ?? json['user_email'];

    final id = idValue?.toString() ?? '';
    final email = emailValue?.toString() ?? '';

    return UserProfileModel(
      id: id,
      email: email,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      companyName: json['company_name'] as String?,
      phoneNumber: (json['phone_number'] ?? json['phone']) as String?,
      role: json['role'] as String?,
      createdAt: parseDate(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? parseDate(json['updated_at'])
          : null,
    );
  }

  /// Convert to JSON
  Json toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'company_name': companyName,
      'phone_number': phoneNumber,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create from entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      companyName: entity.companyName,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
      companyName: companyName,
      phoneNumber: phoneNumber,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
