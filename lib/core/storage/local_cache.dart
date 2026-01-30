import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local cache provider
final localCacheProvider = Provider<LocalCache>((ref) {
  throw UnimplementedError('LocalCache must be overridden');
});

/// Local cache wrapper
class LocalCache {
  final SharedPreferences _prefs;

  LocalCache(this._prefs);

  /// Write string
  Future<bool> writeString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Read string
  String? readString(String key) {
    return _prefs.getString(key);
  }

  /// Write int
  Future<bool> writeInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Read int
  int? readInt(String key) {
    return _prefs.getInt(key);
  }

  /// Write double
  Future<bool> writeDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Read double
  double? readDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Write bool
  Future<bool> writeBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Read bool
  bool? readBool(String key) {
    return _prefs.getBool(key);
  }

  /// Write string list
  Future<bool> writeStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  /// Read string list
  List<String>? readStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Delete key
  Future<bool> delete(String key) async {
    return await _prefs.remove(key);
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Clear all data
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}

/// Cache keys
class CacheKeys {
  CacheKeys._();

  static const String theme = 'theme';
  static const String language = 'language';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';
}
