import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget{
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LoginInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured =! _isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(136, 136, 136, 0.612))
          ),
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
                  color: Colors.grey[700],
                )
              )
            : 
            null,
        ),
      ),
    );
  } 
}