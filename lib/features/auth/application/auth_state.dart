import 'package:equatable/equatable.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';

/// Auth state
class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [status, user, errorMessage, isLoading];

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Initial state
  factory AuthState.initial() => const AuthState();

  /// Loading state
  factory AuthState.loading() =>
      const AuthState(status: AuthStatus.loading, isLoading: true);

  /// Authenticated state
  factory AuthState.authenticated(UserProfile user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  /// Unauthenticated state
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  /// Error state
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}

/// Auth status enum
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }
