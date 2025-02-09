import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Screens
import 'package:frontend/screens/dashboard/login_screen.dart';

// Constants
import 'package:frontend/constants/colors.dart';

class CustomSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  final Auth auth = Auth();
  bool isExpanded = false;

  void handleItemTap(int index) {
    setState(() {
      widget.onItemTapped(index);
      isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 300 : 50,
      color: isExpanded ? myColor : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          IconButton(
            icon: Icon(
              isExpanded ? Icons.arrow_back_ios : Icons.menu,
              color: isExpanded ? baseColor : myColor,
            ),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          SidebarItem(
            icon: IconlyLight.chart,
            label: 'Dashboard',
            isSelected: widget.selectedIndex == 0,
            onTap: () => handleItemTap(0),
            isExpanded: isExpanded, 
          ),
          SidebarItem(
            icon: IconlyLight.add_user, 
            label: 'User catalogue', 
            isSelected: widget.selectedIndex == 1, 
            onTap: () => handleItemTap(1), 
            isExpanded: isExpanded
          ),
          SidebarItem(
            icon: IconlyLight.category, 
            label: 'Product category', 
            isSelected: widget.selectedIndex == 2, 
            onTap: () => handleItemTap(2), 
            isExpanded: isExpanded
          ),
          ElevatedButton(
            onPressed: () async {
              bool logout = await auth.logout();
              if (logout) {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => LoginScreen())
                );
              } else {
                print("Error with logout");
              }
            }, 
            child: Text("Logout")
          )
        ]
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isExpanded;

  const SidebarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Container(
              width: isExpanded ? 280 : 0.05, 
              height: 50,
              decoration: BoxDecoration(
                color: isSelected && isExpanded ? baseColor : Colors.transparent, 
              ),
              padding: EdgeInsets.symmetric(horizontal: isExpanded ? 10 : 1), 
              child: Row(
                children: [
                  if (isExpanded) ...[
                    Icon(
                      icon,
                      color: isSelected && isExpanded ? myColor : baseColor,
                    ),
                    const SizedBox(width: 16),
                    Expanded( 
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected && isExpanded ? myColor : baseColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
