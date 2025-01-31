import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

class LoginButton extends StatefulWidget{
  final Function() onTap;

  LoginButton({
    super.key,
    required this.onTap
  });

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: myColor,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}