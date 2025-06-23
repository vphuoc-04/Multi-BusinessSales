import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget{
  final String? firstName;
  
  const DashboardScreen({Key? key, this.firstName}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: Text('Trang Dashboard'),
      ),
    );
  }
}