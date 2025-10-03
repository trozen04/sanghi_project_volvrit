import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _prefs;

  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyUserToken = 'userToken';
  static const String _keyFcmToken = 'fcmToken';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  static void setLoggedIn(bool value) {
    _prefs!.setBool(_keyIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  static void setUserId(String userId) {
    _prefs!.setString(_keyUserId, userId);
  }

  static String getUserId() {
    return _prefs!.getString(_keyUserId)!;
  }

  static void setUserToken(String userToken) {
    _prefs!.setString(_keyUserToken, userToken);
  }

  static String getUserToken() {
    return _prefs!.getString(_keyUserToken)!;
  }

  static void setUserName(String name) {
    _prefs!.setString(_keyUserName, name);
  }

  static String getUserName() {
    return _prefs!.getString(_keyUserName)!;
  }

  static void setUserEmail(String email) {
    _prefs!.setString(_keyUserEmail, email);
  }

  static String getUserEmail() {
    return _prefs!.getString(_keyUserEmail)!;
  }

  static Future<void> setFcmToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyFcmToken, token);
  }

  static Future<String?> getFcmToken() async {
    await _ensureInitialized();
    return _prefs?.getString(_keyFcmToken); // safely nullable
  }


  static Future<void> clearPrefs() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }
}
