import 'package:flutter/material.dart';
import 'package:frontend/components/dashboard/layout/custom_sidebar.dart';

// Screens
import 'package:frontend/screens/dashboard/dashboard_screen.dart';
import 'package:frontend/screens/dashboard/supplier_screen.dart';
import 'package:frontend/screens/dashboard/user_catalogue_screen.dart';
import 'package:frontend/screens/dashboard/product_category_screen.dart';

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
      DashboardScreen(),
      UserCatalogueScreen(),
      ProductCategoryScreen(),
      SupplierScreen()
    ];
  }

  void onSidebarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomSidebar(
            selectedIndex: selectedIndex,
            onItemTapped: onSidebarItemTapped,
          ),
          Expanded(
            child: screens[selectedIndex]
          )
        ],
      ),
    );
  }
}