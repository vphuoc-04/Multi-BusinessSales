import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Apps
import 'package:frontend/apps/business_app.dart';

// Modules
import 'package:frontend/modules/users/auth/auth.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Business App starting...");

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
      print('Refresh token failed, logging out...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('id');
      auth.logout();
      token = null;
    }
  }

  runApp(BusinessApp(initialRoute: token == null ? '/login' : '/dashboard', id: id,));
}
