// components/business/layouts/custom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: myColor,
      unselectedItemColor: colorNav,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.chart),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.buy),
          label: 'POS',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyBold.category),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}
