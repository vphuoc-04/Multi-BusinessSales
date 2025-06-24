import 'package:flutter/material.dart';

import 'package:frontend/components/business-components/order-components/order_product.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreennState createState() => _OrderScreennState();
}

class _OrderScreennState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Center(child: OrderProduct()),
      ),
    );
  }
}
