import 'dart:convert';

import 'package:frontend/modules/attributes/models/attribute_value.dart';

class Attribute {
  final int id;
  final String name;
  final int addedBy;
  final int? editedBy;
  final List<AttributeValue> attributeValue;

  Attribute({
    required this.id,
    required this.name,
    required this.addedBy,
    this.editedBy,
    required this.attributeValue
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'], 
      name: json['name'] ?? '',
      addedBy: json['addedBy'],
      editedBy: json['editedBy'] ?? 0,
      attributeValue: (json['attributeValue'] as List<dynamic>?)
                      ?.map((attributeValues) => AttributeValue.fromJson(attributeValues))
                      .toList() ?? [],
    );
  } 

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'addedBy': addedBy,
      'editedBy': editedBy,
      'attributeValue': attributeValue.map((attributeValues) => attributeValues.toJson()).toList(),
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}