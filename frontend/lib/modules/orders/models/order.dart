class Order {
  final int id;
  final int productId;
  final String productCode;
  final String name;
  final double price;
  final String img;
  final int quantity;
  final DateTime invoiceDate;

  Order({
    required this.id,
    required this.productId,
    required this.productCode,
    required this.name,
    required this.price,
    required this.img,
    required this.quantity,
    required this.invoiceDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      productId: json['product_id'] ?? 0, 
      productCode: json['product_code'],
      name: json['name'] ?? '', 
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0, 
      quantity: json['quantity'] ?? 0, 
      img: json['img'] ?? '', 
      invoiceDate: json['invoice_date'] != null ? DateTime.parse(json['invoice_date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_code': productCode,
      'name': name,
      'price': price,
      'quantity': quantity,
      'invoice_date': invoiceDate.toIso8601String(),
    };
  }

  Order copyWith({
    int? id,
    int? productId,
    String? productCode,
    String? name,
    double? price,
    String? img,
    int? quantity,
    DateTime? invoiceDate,
  }) {
    return Order(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productCode: productCode ?? this.productCode,
      name: name ?? this.name,
      price: price ?? this.price,
      img: img ?? this.img,
      quantity: quantity ?? this.quantity,
      invoiceDate: invoiceDate ?? this.invoiceDate,
    );
  }
}
