import 'package:hive/hive.dart';

class PreferencesRepository {
  // We grab the box we already opened in main.dart
  final _box = Hive.box('babyshophub_preferences');

  // Key names stored as constants to prevent typos
  static const String _tokenKey = 'jwt_token';

  /// Save the token
  Future<void> saveToken(String token) async {
    await _box.put(_tokenKey, token);
  }

  /// Retrieve the token
  String? getToken() {
    return _box.get(_tokenKey);
  }

  /// Check if a user is logged in
  bool isLoggedIn() {
    return _box.containsKey(_tokenKey) && _box.get(_tokenKey) != null;
  }

  /// Delete the token (Log out)
  Future<void> clearToken() async {
    await _box.delete(_tokenKey);
  }

  void setToken(String token) {}
}
