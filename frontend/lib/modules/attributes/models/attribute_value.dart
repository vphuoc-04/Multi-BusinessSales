import 'dart:convert';

class AttributeValue {
  final int id;
  final String value;
  final int? attributeId;

  AttributeValue({
    required this.id,
    required this.value,
    this.attributeId
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'], 
      value: json['value'], 
      attributeId: json['attributeId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'attributeId': attributeId
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}