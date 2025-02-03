import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tokens
import 'package:frontend/tokens/token.dart';
import 'package:frontend/tokens/auto_refresh_token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Screens
import 'package:frontend/screens/dashboard/layout_screen.dart';
import 'package:frontend/screens/dashboard/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Auth auth = Auth();

  String? token = await Token.loadToken();
  int? id;

  if (token != null) {
    final autoRefresh = AutoRefreshToken();
    bool isRefreshed = await autoRefresh.autoRefreshToken();  

    if (isRefreshed) {
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

  runApp(MyApp(initialRoute: token == null ? '/' : '/dashboard', id: id));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final int? id; 

  const MyApp(
    {super.key, required this.initialRoute, this.id}
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      },
    );
  }
}
