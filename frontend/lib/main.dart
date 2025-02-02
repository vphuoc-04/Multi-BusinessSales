import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Screens
import 'package:frontend/screens/dashboard/layout_screen.dart';
import 'package:frontend/screens/dashboard/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? token = await Token.loadToken();
  int? id;

  if (token != null) {
    final check = await SharedPreferences.getInstance();
    id = check.getInt('id');
    print('User id check: $id');
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      },
    );
  }
}