import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageProvider {
  late FlutterSecureStorage storage;

  initialize() {
    storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
  }

  write({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  read({required String key}) async {
    final result = await storage.read(key: key);
    if (result != null) {
      return result;
    } else {
      return "";
    }
  }
}
