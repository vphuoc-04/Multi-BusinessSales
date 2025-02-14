import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  final int? id;

  const LayoutScreen({super.key, required this.id});

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            children: [
              Text("Layout")
            ],
          ),
        ),
      ),
    );
  }
}