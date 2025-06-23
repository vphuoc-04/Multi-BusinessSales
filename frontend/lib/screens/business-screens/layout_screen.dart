import 'package:flutter/material.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Components
import 'package:frontend/components/business-components/layout-components/custom_navigation_bar.dart';

// Screens
import 'package:frontend/screens/business-screens/dashboard_screen.dart';
import 'package:frontend/screens/business-screens/order_screen.dart';
import 'package:frontend/screens/business-screens/pos_screen.dart';
import 'package:frontend/screens/business-screens/business_screen.dart';

class LayoutScreen extends StatefulWidget {
  final int? id;

  const LayoutScreen({super.key, required this.id}); 

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedIndex = 0;
  final Auth auth = Auth();

  final List<Widget> screens = [
    DashboardScreen(),
    PosScreen(),
    OrderScreen(),
    BusinessScreen(),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
