import 'order_item.dart';

class Order {
  final int id;
  final int addedBy;
  final String status;
  final double totalAmount;
  final DateTime orderDate;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.addedBy,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      addedBy: json['addedBy'],
      status: json['status'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedBy': addedBy,
      'status': status,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
