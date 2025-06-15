import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Screens
import 'package:frontend/screens/admins/layout_screen.dart';

// Components
import 'package:frontend/components/admins/logins/login_button.dart';
import 'package:frontend/components/admins/logins/login_input.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  int? id;
  bool isLoading = false;

  final Auth auth = Auth();

  void login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Email or password is required",
            textAlign: TextAlign.center,
          ),
          backgroundColor: errorColor,
          duration: Duration(milliseconds: 1000),
        ),
      );
      Future.delayed(Duration(milliseconds: 1000), () {
        ScaffoldMessenger.of(context).clearSnackBars();
      });

      setState(() {
        isLoading = false;
      });

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2)); 
      final response = await auth.login(email, password);

      if (response['success'] == true) {
        String token = response['token'];
        String refreshToken = response['refreshToken'];
        await Token.setToken(token, refreshToken);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LayoutScreen(id: id)),
        );

        print('Login successful: Token: $token, Refresh token: $refreshToken');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error",
              textAlign: TextAlign.center,
            ),
            backgroundColor: errorColor,
          ),
        );
        Future.delayed(Duration(milliseconds: 1000), () {
          ScaffoldMessenger.of(context).clearSnackBars();
        });

        setState(() {
          isLoading = false;
        });

        print('Login failed: ${response['message']}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              LoginInput(
                controller: emailController, 
                hintText: 'Email', 
                obscureText: false
              ),
              SizedBox(height: 10),
              LoginInput(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true
              ),
              SizedBox(height: 10),
              LoginButton(
                isLoading: isLoading,
                onTap: () => login(context)
              )
            ],
          ),
        )
      ),
    );
  }
}