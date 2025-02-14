import 'package:flutter/material.dart';

// Screens
import 'package:frontend/screens/dashboard/login_screen.dart';
import 'package:frontend/screens/dashboard/layout_screen.dart';

class DashboardApp extends StatelessWidget {
  final String initialRoute;
  final int? id;

  const DashboardApp({
    super.key, 
    required this.initialRoute, 
    this.id
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/dashboard/login': (context) => LoginScreen(),
        '/dashboard': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      },
    );
  }
}