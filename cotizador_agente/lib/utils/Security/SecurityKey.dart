import 'package:flutter_keychain/flutter_keychain.dart';

class SecurityKey {
  Future<String> getKey(String keyName) async {
    return await FlutterKeychain.get(key: keyName);
  }

  Future<void> putKey(String keyName, String keyValue) async {
    await FlutterKeychain.put(key: keyName, value: keyValue);
  }

  void clearData() async {
    await FlutterKeychain.clear();
  }
}
