import 'package:mobx/mobx.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'storage.g.dart';

class StorageProvider = _StorageProvider with _$StorageProvider;

abstract class _StorageProvider with Store {
  late FlutterSecureStorage storage;

  @action
  initialize() {
    storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
  }

  @action
  write({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  @action
  read({required String key}) async {
    final result = await storage.read(key: key);
    if (result != null) {
      return result;
    } else {
      return "";
    }
  }
}
