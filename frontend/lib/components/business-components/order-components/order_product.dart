import 'package:flutter/material.dart';
import 'package:frontend/modules/orders/services/order_service.dart';
import 'package:frontend/modules/orders/models/order.dart';
import 'package:iconly/iconly.dart';

class OrderProduct extends StatefulWidget {
  @override
  _OrderProductState createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  final OrderService orderService = OrderService();
  List<Order> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final List<dynamic> result = await orderService.fetch();
      setState(() {
        cartItems = result.map((json) => Order.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      final result = await orderService.delete(id);
      if (result['success'] == true) {
        setState(() {
          cartItems.removeWhere((item) => item.id == id);
        });
      }
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (cartItems.isEmpty) {
      return Center(child: Text('Không có đơn hàng nào!'));
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(206, 177, 177, 177)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thông tin đơn hàng
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mã đơn: #${item.id}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Tổng tiền: ${item.totalAmount} VNĐ"),
                      Text("Trạng thái: ${item.status}"),
                      SizedBox(height: 4),
                      Text("Ngày đặt: ${item.orderDate.toString().split('T')[0]}"),
                    ],
                  ),
                ),
                // Nút xóa
                InkWell(
                  onTap: () => deleteOrder(item.id),
                  child: Ink(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(67, 169, 162, 1),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        IconlyLight.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
