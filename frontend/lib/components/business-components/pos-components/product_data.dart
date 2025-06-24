import 'package:flutter/material.dart';
import 'package:frontend/components/business-components/order-components/attribute_selection_dialog.dart';

// Constants
import 'package:frontend/constants/colors.dart';
import 'package:frontend/modules/attributes/models/attribute_value.dart';
import 'package:frontend/modules/orders/services/order_item_attribute_service.dart';

// Models
import 'package:frontend/modules/products/models/product.dart';

// Services
import 'package:frontend/modules/orders/services/order_service.dart';
import 'package:frontend/modules/orders/services/order_item_service.dart';

// Widgets
import 'package:frontend/widgets/loading_widget.dart';

class ProductData extends StatelessWidget {
  final List<Product> products;

  ProductData({Key? key, required this.products}) : super(key: key);

  final OrderService orderService = OrderService();
  final OrderItemService orderItemService = OrderItemService();
  final OrderItemAttributeService orderItemAttributeService = OrderItemAttributeService();

  void _handleAddOrderWithAttribute(BuildContext context, Product product) async {
    try {
      final selectedAttributes = await showDialog<List<AttributeValue>>(
        context: context,
        builder: (_) => AttributeSelectionDialog(),
      );

      if (selectedAttributes == null || selectedAttributes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn chưa chọn thuộc tính nào')),
        );
        return;
      }

      final orderResponse = await orderService.add(
        userId: 1,
        totalAmount: product.price.toDouble(),
        items: [],
      );

      if (orderResponse['success'] != true || orderResponse['data'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm đơn hàng thất bại')),
        );
        return;
      }

      final orderId = orderResponse['data']['id'];

      final orderItemResponse = await orderItemService.add(
        orderId: orderId,
        productId: product.id,
        quantity: 1,
        unitPrice: product.price,
      );

      if (orderItemResponse['success'] != true || orderItemResponse['data'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tạo order item')),
        );
        return;
      }

      final orderItemId = orderItemResponse['data']['id'];

      for (final value in selectedAttributes) {
        await orderItemAttributeService.add(
          orderItemId: orderItemId,
          attributeValueId: value.id!,
        );
      }

      final selectedAttrText = selectedAttributes.map((e) => e.value).join(", ");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Đã đặt hàng: ${product.name} | Giá: ${product.price} VNĐ | Thuộc tính: $selectedAttrText',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm đơn hàng: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, left: 17, right: 17),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.imageUrls.length,
                              itemBuilder: (context, imgIndex) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product.imageUrls[imgIndex].replaceFirst(RegExp(r'^/'), ''),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded || frame != null) {
                                          return child;
                                        } else {
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            alignment: Alignment.center,
                                            child: LoadingWidget(size: 30, color: myColor),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          '${product.price} VNĐ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: myColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _handleAddOrderWithAttribute(context, product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Thêm sản phẩm', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}