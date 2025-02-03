import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

class AutoRefreshToken {
  static String? token;

  final Auth auth = Auth();

  Future<http.Response> handleRequest(Future<http.Response> Function() request) async {
    http.Response response = await request();

    if (response.statusCode == 401) {
      print('Token expired! Refreshing...');

      bool isRefreshed = await autoRefreshToken();
      if (isRefreshed) {
        print('Token refreshed, resend request...');
        return await request();
      } else {
        print('Refresh token failed! Log out...');
        await auth.logout();
        return http.Response(jsonEncode({'error': 'Session expired'}), 401);
      }
    }
    return response;
  }

  Future<bool> autoRefreshToken() async {
    bool isRefreshed = await auth.refreshToken();

    final prefs = await SharedPreferences.getInstance();
    if (isRefreshed) {
      token = prefs.getString('token');
      return true;
    } else {
      await prefs.remove('token'); 
      return false;
    }
  }
}