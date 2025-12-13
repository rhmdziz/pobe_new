import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  AuthStorage({FlutterSecureStorage? secureStorage})
      : _secure = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secure;

  Future<void> saveTokens(String access, String refresh) async {
    await _secure.write(key: 'access', value: access);
    await _secure.write(key: 'refresh', value: refresh);
  }

  Future<String?> readAccessToken() => _secure.read(key: 'access');

  Future<void> clear() => _secure.deleteAll();
}
