import 'dart:convert';

class Product {
  final int id;
  final int addedBy;
  final int editedBy;
  final int productCategoryId;
  final String productCode;
  final String name;
  final double price;
  final List<String> imageUrls;
  final int? brandId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.addedBy,
    required this.editedBy,
    required this.productCategoryId,
    required this.productCode,
    required this.name,
    required this.price,
    required this.imageUrls,
    this.brandId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      addedBy: json['addedBy'] ?? 0,
      editedBy: json['editedBy'] ?? 0,
      productCategoryId: json['productCategoryId'] ?? 0,
      productCode: json['productCode'] ?? '',
      name: decodeUtf8(json['name'] ?? ''),
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((url) => url.toString())
              .toList() ??
          [],
      brandId: json['brandId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedBy': addedBy,
      'editedBy': editedBy,
      'productCategoryId': productCategoryId,
      'productCode': productCode,
      'name': name,
      'price': price,
       'imageUrls': imageUrls,
      'brandId': brandId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}
