import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtils {
  static const _storage = FlutterSecureStorage();

  static const String isProgramSwitchOnKey = 'isProgramSwitchOnFAS';

  static Future<void> setBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  static Future<bool> getBool(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return false;
    return value.toLowerCase() == 'true';
  }

  static Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
