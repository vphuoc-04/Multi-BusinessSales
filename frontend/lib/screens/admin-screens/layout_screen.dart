import 'package:flutter/material.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Components
import 'package:frontend/components/admin-components/layout-components/custom_sidebar.dart';

// Screens
import 'package:frontend/screens/admin-screens/dashboard_screen.dart';
import 'package:frontend/screens/admin-screens/login_screen.dart';
import 'package:frontend/screens/admin-screens/managements/permission_management_screen.dart';
import 'package:frontend/screens/admin-screens/profile_screen.dart';
import 'package:frontend/screens/admin-screens/welcome_banner.dart';

class LayoutScreen extends StatefulWidget {
  final int? id;
  final String? firstname;

  const LayoutScreen({
    super.key, 
    required this.id, 
    required this.firstname,
  }); 

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedIndex = 0;
  final Auth auth = Auth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (widget.firstname != null && widget.firstname!.isNotEmpty) {
      print('Showing welcome banner in LayoutScreen for: ${widget.firstname}');
  
      await Future.delayed(const Duration(milliseconds: 700)); 
      if (mounted) {
        print('Showing welcome banner in LayoutScreen for: ${widget.firstname}');
        showWelcomeBanner(context, firstname: widget.firstname!);
      }
    }
  });
  }

  final List<Widget> screens = [
    DashboardScreen(),
    ProfileScreen(),
    PermissionManagementScreen(),
  ];

  void _onItemTapped(int index) async {
  if (index == -1) {
    showLogoutBottomSheet(context); 
  } else {
    setState(() {
      selectedIndex = index;
    });
  }
}

void showLogoutBottomSheet(BuildContext parentContext) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: parentContext,
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
                    if (logout && mounted) {
                      Navigator.of(parentContext, rootNavigator: true).pushReplacement(
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
      bottomNavigationBar: CustomSidebar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
        child: screens[selectedIndex],
      ),
    );
  }
}