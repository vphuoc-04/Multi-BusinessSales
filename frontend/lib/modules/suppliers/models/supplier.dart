import 'dart:convert';

class Supplier {
  final int id;
  final String name;

  Supplier({
    required this.id,
    required this.name
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'], 
      name: decodeUtf8(json['name'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}