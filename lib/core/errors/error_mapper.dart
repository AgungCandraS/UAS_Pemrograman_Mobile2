import 'package:bisnisku/core/errors/exceptions.dart' as app_exceptions;
import 'package:bisnisku/core/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

/// Maps exceptions to failures
class ErrorMapper {
  ErrorMapper._();

  /// Map exception to failure
  static Failure mapExceptionToFailure(Exception exception) {
    if (exception is app_exceptions.ServerException) {
      return ServerFailure(message: exception.message, code: exception.code);
    } else if (exception is app_exceptions.CacheException) {
      return CacheFailure(message: exception.message, code: exception.code);
    } else if (exception is app_exceptions.NetworkException) {
      return NetworkFailure(message: exception.message, code: exception.code);
    } else if (exception is app_exceptions.ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is app_exceptions.AuthException) {
      return AuthFailure(message: exception.message, code: exception.code);
    } else if (exception is app_exceptions.AuthorizationException) {
      return AuthorizationFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is app_exceptions.NotFoundException) {
      return NotFoundFailure(message: exception.message, code: exception.code);
    } else if (exception is AuthApiException) {
      return _mapSupabaseAuthException(exception);
    } else if (exception is PostgrestException) {
      return _mapPostgrestException(exception);
    }

    return ServerFailure(message: exception.toString());
  }

  static Failure _mapSupabaseAuthException(AuthApiException exception) {
    return AuthFailure(message: exception.message, code: exception.code);
  }

  static Failure _mapPostgrestException(PostgrestException exception) {
    return ServerFailure(message: exception.message, code: exception.code);
  }
}
