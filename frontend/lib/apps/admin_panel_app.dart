import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Screens
import 'package:frontend/screens/admin-screens/layout_screen.dart';
import 'package:frontend/screens/admin-screens/login_screen.dart';


class AdminPanelApp extends StatelessWidget {

  final String initialRoute;
  final int? id;
  final String? firstName;

  const AdminPanelApp({
    super.key,
    required this.initialRoute,
    this.id,
    this.firstName
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: myColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 70,
          toolbarHeight: 100, 
        ),
      ),
      routes: {
        '/admin_panel/login': (context) => LoginScreen(),
        '/admin_panel/dashboard': (context) 
          => id == null ? LoginScreen() : LayoutScreen(id: id!, firstname: firstName,)
      },
    );
  }
}