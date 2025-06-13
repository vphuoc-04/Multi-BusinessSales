import 'package:flutter/material.dart';

// Screens
import 'package:frontend/screens/business/layout_screen.dart';
import 'package:frontend/screens/business/login_screen.dart';

class BusinessApp extends StatelessWidget {
  final String initialRoute;
  final int? id;

  const BusinessApp({
    super.key,
    required this.initialRoute,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      },
    );
  }
}
