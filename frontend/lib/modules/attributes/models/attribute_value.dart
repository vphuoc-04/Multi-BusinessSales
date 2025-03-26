import 'dart:convert';

class AttributeValue {
  final int? id; 
  final String value;
  final int? attributeId;
  final int addedBy;
  final int? editedBy;

  AttributeValue({
    this.id,
    required this.value,
    this.attributeId,
    required this.addedBy,
    this.editedBy,
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'], 
      value: json['value'] ?? '',
      attributeId: json['attributeId'],
      addedBy: json['addedBy'] ?? 0, 
      editedBy: json['editedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'attributeId': attributeId,
      'addedBy': addedBy,
      'editedBy': editedBy,
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}