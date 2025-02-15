import 'package:flutter/material.dart';

// Components
import 'package:frontend/components/pos/layout/custom_navigation_bar.dart';

// Screens
import 'package:frontend/screens/pos/profile_screen.dart';
import 'package:frontend/screens/pos/home_screen.dart';

class LayoutScreen extends StatefulWidget {
  final int? id;

  const LayoutScreen({super.key, required this.id});

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedIndex = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = <Widget> [
      HomeScreen(),
      ProfileScreen()
    ];
  }

  void onItemNavigationBarTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: screens[selectedIndex]
          )
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemNavigationBarTapped,
      ),
    );
  }
}