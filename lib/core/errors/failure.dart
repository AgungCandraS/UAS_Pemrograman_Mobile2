import 'package:equatable/equatable.dart';

/// Base failure class for error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/// Server failure (API errors)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Cache failure (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Network failure (connection errors)
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Validation failure (input validation errors)
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Authorization failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({required super.message, super.code});
}

/// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code});
}
