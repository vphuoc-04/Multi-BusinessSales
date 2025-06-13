import 'package:flutter/material.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Components
import 'package:frontend/components/business/layouts/custom_navigation_bar.dart';

// Screens
import 'package:frontend/screens/business/dashboard_screen.dart';
import 'package:frontend/screens/business/pos_screen.dart';
import 'package:frontend/screens/business/business_screen.dart';
import 'package:frontend/screens/business/login_screen.dart';

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
    BusinessScreen(),
  ];

  // void _onItemTapped(int index) async {
  //   if (index == 3) {
  //     // Logout
  //     bool logout = await auth.logout();
  //     if (logout) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //       );
  //     } else {
  //       print("Logout failed");
  //     }
  //   } else {
  //     setState(() {
  //       selectedIndex = index;
  //     });
  //   }
  // }

    void _onItemTapped(int index) async {
    if (index == 3) {
      _showLogoutBottomSheet();
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void _showLogoutBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: 130,
          child: Column(
            children: [
              const Text(
                'Bạn có chắc chắn muốn đăng xuất?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Không',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      bool logout = await auth.logout();
                      if (logout) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      } else {
                        print("Logout failed");
                      }
                    },
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
