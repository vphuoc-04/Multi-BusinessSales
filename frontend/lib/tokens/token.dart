import 'package:shared_preferences/shared_preferences.dart';

class Token {
  static String tokenKey = 'token';

  // Set token
  static Future<void> setToken(String token) async {
    final set = await SharedPreferences.getInstance();
    await set.setString(tokenKey, token);
    print("Token saved: $token");
  }

  // Load token
  static Future<String?> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("Token loaded: $token");
    return token;
  }
}