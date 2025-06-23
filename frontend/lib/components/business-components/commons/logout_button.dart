import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Screens
import 'package:frontend/screens/business-screens/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutBottomSheet(BuildContext context) {
    final Auth auth = Auth();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (sheetContext) {
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
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text(
                      'Không',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      bool logout = await auth.logout();
                      if (logout && context.mounted) {
                        // Use a Builder to ensure a valid context for navigation
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                      } else if (!logout) {
                        print("Logout failed");
                      } else {
                        print("Context is not mounted, cannot navigate");
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () => _showLogoutBottomSheet(context),
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: myColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}