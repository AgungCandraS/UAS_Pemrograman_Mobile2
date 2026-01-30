import 'package:equatable/equatable.dart';

/// Two-Factor Authentication entity
class TwoFactorAuth extends Equatable {
  final String userId;
  final bool enabled;
  final String? method; // sms, email, totp
  final String? verificationSent;
  final DateTime? enabledAt;
  final List<String>? backupCodes;

  const TwoFactorAuth({
    required this.userId,
    this.enabled = false,
    this.method,
    this.verificationSent,
    this.enabledAt,
    this.backupCodes,
  });

  @override
  List<Object?> get props => [
    userId,
    enabled,
    method,
    verificationSent,
    enabledAt,
    backupCodes,
  ];
}
