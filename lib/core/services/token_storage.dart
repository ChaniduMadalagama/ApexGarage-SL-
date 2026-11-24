import 'package:hive/hive.dart';

class TokenStorage {
  static const String boxName = 'apex_auth_box';
  static const String _tokenKey = 'sanctum_token';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }

  String? getToken() {
    if (!Hive.isBoxOpen(boxName)) return null;
    final token = Hive.box<String>(boxName).get(_tokenKey);
    if (token == null || token.isEmpty) return null;
    return token;
  }

  Future<void> saveToken(String token) async {
    await init();
    await Hive.box<String>(boxName).put(_tokenKey, token);
  }

  Future<void> clearToken() async {
    if (!Hive.isBoxOpen(boxName)) return;
    await Hive.box<String>(boxName).delete(_tokenKey);
  }
}
