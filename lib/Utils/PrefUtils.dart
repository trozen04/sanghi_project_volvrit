  import 'package:shared_preferences/shared_preferences.dart';

  class Prefs {
    // Key for isLoggedIn
    static const String _keyIsLoggedIn = 'isLoggedIn';

    // Save login status
    static Future<void> setLoggedIn(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, value);
    }

    // Get login status
    static Future<bool> isLoggedIn() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false; // default false
    }

    // Clear all preferences (optional)
    static Future<void> clearPrefs() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }
