import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Screens
import 'package:frontend/screens/dashboard/layout_screen.dart';

// Components
import 'package:frontend/components/dashboard/login/login_button.dart';
import 'package:frontend/components/dashboard/login/login_input.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  int? id;

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
      return;
    }

    try {
      await Future.delayed(Duration(seconds: 2)); 
      final response = await auth.login(email, password);

      if (response['success'] == true) {
        String token = response['token'];
        await Token.setToken(token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LayoutScreen(id: id!,)),
        );

        print('Login successful: Token: $token');
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
                onTap: () => login(context)
              )
            ],
          ),
        )
      ),
    );
  }
}