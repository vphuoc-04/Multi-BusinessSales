import 'package:flutter/material.dart';

// Constants
import 'package:frontend/constants/colors.dart';

class LoginInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LoginInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  late bool _isObscured;
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode.addListener(() {
      setState(() {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              isFocused = _focusNode.hasFocus;
            });
          }
        });
      });
    });
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(136, 136, 136, 0.612),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: myColor,
              width: 1.3,
            ),
          ),
          // Use a custom border for smooth transition
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 15,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: _toggleObscureText,
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: _isObscured ? Colors.grey[700] : myColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}