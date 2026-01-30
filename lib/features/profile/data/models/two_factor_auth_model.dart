import 'package:bisnisku/features/profile/domain/entities/two_factor_auth.dart';

/// Two-Factor Auth model for JSON serialization
class TwoFactorAuthModel extends TwoFactorAuth {
  const TwoFactorAuthModel({
    required super.userId,
    super.enabled,
    super.method,
    super.verificationSent,
    super.enabledAt,
    super.backupCodes,
  });

  factory TwoFactorAuthModel.fromJson(Map<String, dynamic> json) {
    return TwoFactorAuthModel(
      userId: json['user_id'] as String,
      enabled: json['enabled'] as bool? ?? false,
      method: json['method'] as String?,
      verificationSent: json['verification_sent'] as String?,
      enabledAt: json['enabled_at'] != null
          ? DateTime.parse(json['enabled_at'] as String)
          : null,
      backupCodes: List<String>.from(
        json['backup_codes'] as List<dynamic>? ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'enabled': enabled,
    'method': method,
    'verification_sent': verificationSent,
    'enabled_at': enabledAt?.toIso8601String(),
    'backup_codes': backupCodes,
  };
}
