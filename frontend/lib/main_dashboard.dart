import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Apps
import 'package:frontend/apps/dashboard_app.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Dashboard is running...");

  final Auth auth = Auth();

  String? token = await Token.loadToken();
  int? id;

  if (token != null) {
    bool refreshToken = await auth.refreshToken(); 

    if (refreshToken) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      id = prefs.getInt('id');
      print('Valid token! ID: $id');
    } else {
      print('Refresh token failed, logged out...');
      token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('id');

      auth.logout();
    }
  }

  runApp(DashboardApp(initialRoute: token == null ? '/dashboard/login' : '/dashboard', id: id,));
}