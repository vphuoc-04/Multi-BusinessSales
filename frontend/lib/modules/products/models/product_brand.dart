import 'dart:convert';

class ProductBrand {
  final int id;
  final int addedBy;
  final int editedBy;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductBrand({
    required this.id,
    required this.addedBy,
    required this.editedBy,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      id: json['id'] ?? 0,
      addedBy: json['addedBy'] ?? 0,
      editedBy: json['editedBy'] ?? 0,
      name: _decodeUtf8(json['name'] ?? ''),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedBy': addedBy,
      'editedBy': editedBy,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String _decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}
