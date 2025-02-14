import 'package:flutter/material.dart';

// Screens
import 'package:frontend/screens/pos/login_screen.dart';
import 'package:frontend/screens/pos/layout_screen.dart';

class PosApp extends StatelessWidget {
  final String initialRoute;
  final int? id;

  const PosApp({
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
        '/pos/login': (context) => LoginScreen(),
        '/pos/home': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      }
    );
  }
}