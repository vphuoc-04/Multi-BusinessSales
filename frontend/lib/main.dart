import 'package:flutter/material.dart';

// Screens
import 'package:frontend/screens/dashboard/dashboard_screen.dart';
import 'package:frontend/screens/dashboard/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen()
      }
    );
  }
}

