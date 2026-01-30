import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer utility for delaying function calls
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  /// Call the action after delay
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler utility for rate-limiting function calls
class Throttler {
  final Duration duration;
  Timer? _timer;
  bool _canExecute = true;

  Throttler({required this.duration});

  /// Call the action with throttling
  void call(VoidCallback action) {
    if (_canExecute) {
      action();
      _canExecute = false;
      _timer = Timer(duration, () {
        _canExecute = true;
      });
    }
  }

  /// Cancel throttle timer
  void cancel() {
    _timer?.cancel();
    _canExecute = true;
  }

  /// Dispose the throttler
  void dispose() {
    _timer?.cancel();
  }
}
