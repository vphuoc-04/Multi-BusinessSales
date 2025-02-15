import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Components
import 'package:frontend/components/pos/profile/user_profile_data.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Models
import 'package:frontend/modules/users/models/user.dart';

// Services
import 'package:frontend/modules/users/services/user_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

// Screens
import 'package:frontend/screens/pos/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();
  final Auth auth = Auth();

  User? userData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserById();
  }

  Future<void> fetchUserById() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id'); 

    setState(() {
      isLoading = true;
    });

    if (userId != null) {
      try {
        userData = await userService.user(userId);
      } 
      catch (error) {
        print('Error fetching user data: $error');
      } 
      finally {
        setState(() {
          isLoading = false;
        });
      }
    } 
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: isLoading
                ? LoadingWidget(size: 20, color: myColor,)
                : Column(
                  children: [
                    if (userData != null) 
                      Column(
                        children: [
                          UserProfileData(data: userData!)
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        await auth.logout();
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      }, 
                      child: Text("Logout")
                    )
                  ],
                )
          ),
        ),
      ),
    );
  }
}
