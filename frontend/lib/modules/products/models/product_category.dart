import 'dart:convert';

class ProductCategory {
  final int id;
  final String name;
  final int publish;

  ProductCategory({
    required this.id,
    required this.name,
    required this.publish
  });

  factory ProductCategory.fromJson (Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0, 
      name: decodeUtf8(json['name'] ?? ''), 
      publish: json['publish'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'publish': publish
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}