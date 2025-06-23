import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Constants
import 'package:frontend/constants/colors.dart';

class CustomSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final Widget child;

  const CustomSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.child,
  });

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool isSidebarOpen = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: [
              widget.child, 
              Positioned(
                top: 30,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSidebarOpen = !isSidebarOpen;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSidebarOpen ? Icons.close : Icons.menu,
                      color: myColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isSidebarOpen)
          GestureDetector(
            onTap: () {
              setState(() {
                isSidebarOpen = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: isSidebarOpen ? 0 : -300,
          top: 0,
          bottom: 0,
          width: 280,
          child: Material(
            elevation: 8,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header với nút đóng
                  Container(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isSidebarOpen = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        buildListTile(
                          icon: IconlyLight.chart,
                          title: 'Dashboard',
                          index: 0,
                        ),
                        buildListTile(
                          icon: IconlyLight.user,
                          title: 'Profile',
                          index: 1,
                        ),
                        buildListTile(
                          icon: Icons.admin_panel_settings_outlined, 
                          title: 'Permissions', 
                          index: 2
                        ),
                        const Divider(),
                        buildListTile(
                          icon: IconlyLight.logout,
                          title: 'Logout',
                          index: -1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = widget.selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? myColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          widget.onItemTapped(index);
          if (index != -1) {
            setState(() {
              isSidebarOpen = false;
            });
          }
        },
      ),
    );
  }
}