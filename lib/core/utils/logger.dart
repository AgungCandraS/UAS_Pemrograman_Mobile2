import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// App logger utility
class AppLogger {
  AppLogger._();

  static bool _initialized = false;

  /// Initialize logger
  static void init() {
    if (!_initialized) {
      _initialized = true;
      info('Logger initialized');
    }
  }

  /// Log info message
  static void info(String message, [Object? data]) {
    if (kDebugMode) {
      developer.log(message, name: 'INFO', time: DateTime.now());
      if (data != null) {
        developer.log(data.toString(), name: 'INFO_DATA', time: DateTime.now());
      }
    }
  }

  /// Log success message
  static void success(String message, [Object? data]) {
    if (kDebugMode) {
      developer.log(message, name: 'SUCCESS', time: DateTime.now());
      if (data != null) {
        developer.log(
          data.toString(),
          name: 'SUCCESS_DATA',
          time: DateTime.now(),
        );
      }
    }
  }

  /// Log warning message
  static void warning(String message, [Object? data]) {
    if (kDebugMode) {
      developer.log(message, name: 'WARNING', time: DateTime.now());
      if (data != null) {
        developer.log(
          data.toString(),
          name: 'WARNING_DATA',
          time: DateTime.now(),
        );
      }
    }
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'ERROR',
        error: error,
        stackTrace: stackTrace,
        time: DateTime.now(),
      );
    }
  }

  /// Log debug message
  static void debug(String message, [Object? data]) {
    if (kDebugMode) {
      developer.log(message, name: 'DEBUG', time: DateTime.now());
      if (data != null) {
        developer.log(
          data.toString(),
          name: 'DEBUG_DATA',
          time: DateTime.now(),
        );
      }
    }
  }
}
