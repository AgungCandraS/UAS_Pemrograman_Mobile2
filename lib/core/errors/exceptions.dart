/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Server exception (API errors)
class ServerException extends AppException {
  const ServerException({required super.message, super.code, super.details});
}

/// Cache exception (local storage errors)
class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.details});
}

/// Network exception (connection errors)
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.details});
}

/// Validation exception (input validation errors)
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.details});
}

/// Authorization exception
class AuthorizationException extends AppException {
  const AuthorizationException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Not found exception
class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.code, super.details});
}
