import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();
}

