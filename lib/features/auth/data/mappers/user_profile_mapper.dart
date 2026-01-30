import 'package:bisnisku/features/auth/data/models/user_profile_model.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';

/// Mapper for UserProfile entity and model
class UserProfileMapper {
  UserProfileMapper._();

  /// Convert UserProfileModel to UserProfile entity
  static UserProfile toEntity(UserProfileModel model) {
    return UserProfile(
      id: model.id,
      email: model.email,
      fullName: model.fullName,
      avatarUrl: model.avatarUrl,
      companyName: model.companyName,
      phoneNumber: model.phoneNumber,
      role: model.role,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert UserProfile entity to UserProfileModel
  static UserProfileModel toModel(UserProfile entity) {
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

  /// Convert JSON to UserProfile entity
  static UserProfile fromJson(Map<String, dynamic> json) {
    return toEntity(UserProfileModel.fromJson(json));
  }

  /// Convert UserProfile entity to JSON
  static Map<String, dynamic> toJson(UserProfile entity) {
    return toModel(entity).toJson();
  }
}
