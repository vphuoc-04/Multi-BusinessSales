import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:iconly/iconly.dart';

// Models
import 'package:frontend/modules/orders/models/order.dart';
import 'package:frontend/modules/attributes/models/attribute_value.dart';
import 'package:frontend/modules/products/models/product.dart';

// Services
import 'package:frontend/modules/orders/services/order_service.dart';
import 'package:frontend/modules/orders/services/order_item_service.dart';
import 'package:frontend/modules/orders/services/order_item_attribute_service.dart';
import 'package:frontend/modules/products/services/product_service.dart';
import 'package:frontend/modules/attributes/services/attribute_value_service.dart';

// Dialog
import 'package:frontend/components/business-components/order-components/attribute_selection_dialog.dart';

class OrderProduct extends StatefulWidget {
  @override
  _OrderProductState createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  final OrderService orderService = OrderService();
  final OrderItemService orderItemService = OrderItemService();
  final OrderItemAttributeService orderItemAttributeService = OrderItemAttributeService();
  final ProductService productService = ProductService();
  final AttributeValueService attributeValueService = AttributeValueService();

  List<Order> cartItems = [];
  Map<int, String> productIdNameMap = {};
  Map<int, String> attributeValueIdNameMap = {}; // map id -> tên thuộc tính

  bool isLoading = true;
  bool isProductMapLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    preloadProductNames();
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

  Future<void> preloadProductNames() async {
    try {
      final products = await productService.fetchProducts();
      setState(() {
        productIdNameMap = {
          for (var p in products) p.id: p.name,
        };
        isProductMapLoading = false;
      });
    } catch (e) {
      print("Lỗi khi fetch products: $e");
      setState(() {
        isProductMapLoading = false;
      });
    }
  }

  Future<void> fetchAttributeValueName(int id) async {
    if (attributeValueIdNameMap.containsKey(id)) return;

    try {
      final values = await attributeValueService.fetchById(id);
      if (values.isNotEmpty) {
        setState(() {
          attributeValueIdNameMap[id] = values.first.value;
        });
      }
    } catch (e) {
      print("❌ Error loading attribute name for id $id: $e");
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
      print("Lỗi khi xóa đơn: $e");
    }
  }

  Future<void> addOrderItemWithAttributes(Order order) async {
    try {
      final selectedValues = await showDialog<List<AttributeValue>>(
        context: context,
        builder: (_) => AttributeSelectionDialog(),
      );

      if (selectedValues == null || selectedValues.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bạn chưa chọn thuộc tính nào")),
        );
        return;
      }

      for (final item in order.items) {
        final orderItemResult = await orderItemService.add(
          orderId: order.id,
          productId: item.productId,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
        );

        if (orderItemResult['success'] != true || orderItemResult['data']?['id'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Không thể tạo OrderItem")),
          );
          continue;
        }

        final orderItemId = orderItemResult['data']['id'];

        for (final value in selectedValues) {
          await orderItemAttributeService.add(
            orderItemId: orderItemId,
            attributeValueId: value.id!,
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã thêm sản phẩm và thuộc tính vào đơn hàng")),
      );
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi xảy ra khi thêm thuộc tính")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || isProductMapLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (cartItems.isEmpty) {
      return Center(child: Text('Không có đơn hàng nào!'));
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final order = cartItems[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(206, 177, 177, 177)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📦 Mã đơn: #${order.id}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("💵 Tổng tiền: ${order.totalAmount} VNĐ"),
                Text("📅 Ngày đặt: ${order.orderDate.toString().split('T')[0]}"),
                Text("📦 Trạng thái: ${order.status}", style: TextStyle(color: Colors.blue)),

                const SizedBox(height: 10),

                ...order.items.map((item) {
                  final productName = productIdNameMap[item.productId] ?? 'Không rõ';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🛒 Sản phẩm: $productName", style: TextStyle(fontWeight: FontWeight.w600)),
                      Text("🔢 Số lượng: ${item.quantity}"),
                      Text("💲 Đơn giá: ${item.unitPrice} VNĐ"),

                      if (item.attributes.isNotEmpty) ...[
                        Text("🎯 Thuộc tính:", style: TextStyle(fontWeight: FontWeight.w500)),
                        ...item.attributes.map((attr) {
                          final name = attributeValueIdNameMap[attr.attributeValueId];
                          if (name == null) {
                            fetchAttributeValueName(attr.attributeValueId); // gọi load nếu chưa có
                          }
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("- ${name ?? 'Đang tải...'}"),
                          );
                        }),
                      ],
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => addOrderItemWithAttributes(order),
                      child: Text("Thêm thuộc tính", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: myColor),
                    ),
                    InkWell(
                      onTap: () => deleteOrder(order.id),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: myColor,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(IconlyLight.delete, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
