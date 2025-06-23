import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Screens
import 'package:frontend/screens/business-screens/layout_screen.dart';
import 'package:frontend/screens/business-screens/login_screen.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: myColor,
          elevation: 0,
          scrolledUnderElevation: 0, 
          surfaceTintColor: Colors.transparent, 
        ),
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => id == null ? LoginScreen() : LayoutScreen(id: id!)
      },
    );
  }
}
