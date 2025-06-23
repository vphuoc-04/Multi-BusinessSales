import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/modules/orders/services/order_service.dart';
import 'package:iconly/iconly.dart';

// Models
import 'package:frontend/modules/orders/models/order.dart';

class OrderProduct extends StatefulWidget {
  @override
  _OrderProductState createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  final OrderService orderService = OrderService();
  List<Order> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchOrderProductItems();
  }

  // Get product data in orders
  Future<void> fetchOrderProductItems() async {
    var items = await orderService.getDataCart(); 
    setState(() {
      cartItems = items;
    });
  }

  // Delete product data in orders
  Future<void> removeOrderProductItem(int cartItemId) async {
    bool success = await orderService.removeCartItem(cartItemId);

    if (success) {
      setState(() {
        cartItems.removeWhere((item) {
          if (item.id == cartItemId) {
            print('Removing item with ID: ${item.id}');
            return true;
          }
          return false;
        });
      });
    }
    else {
      print('Failed to delete item!');
    }
  }

  // Change prodcut data in orders
  Future<void> updateOrderProductQuantity(int cartItemId, int newQuantity) async {
    bool success = await orderService.changeQuantity(cartItemId, newQuantity);

    if (success) {
      setState(() {
        cartItems = cartItems.map((item) {
          if (item.id == cartItemId) {
            double newPrice = item.price / item.quantity * newQuantity;  
            return item.copyWith(quantity: newQuantity, price: newPrice); 
          }
          return item;
        }).toList();
      });
    } else {
      print('Failed to update quantity!');
    }
  }


  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Center(
        child: Text('Không có đơn hàng nào!'),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: cartItems.map((item) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: 400,
                  height: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromARGB(206, 177, 177, 177)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            item.img,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ), 
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('${item.price} VNĐ'),
                                  SizedBox(width: 10),
                                  InkWell(
                                      onTap: () {
                                      if (item.quantity > 1) {
                                        updateOrderProductQuantity(item.id, item.quantity - 1);
                                      }
                                    },
                                    child: Ink(
                                      child: Container(
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(67, 169, 162, 1),
                                          borderRadius: BorderRadius.circular(60),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.minus, 
                                          color: Color.fromRGBO(255, 255, 255, 50),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text('${item.quantity}'),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      updateOrderProductQuantity(item.id, item.quantity + 1);
                                    },
                                    child: Ink(
                                      child: Container(
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(67, 169, 162, 1),
                                          borderRadius: BorderRadius.circular(60),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.add, 
                                          color: Color.fromRGBO(255, 255, 255, 50),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          await removeOrderProductItem(item.id);
                        },
                        child: Ink(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(67, 169, 162, 1),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Icon(
                              IconlyLight.delete, 
                              color: Color.fromRGBO(255, 255, 255, 50),
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      )
    );
  }
}