class OrderItemAttribute {
  final int id;
  final int attributeValueId;

  OrderItemAttribute({
    required this.id,
    required this.attributeValueId,
  });

  factory OrderItemAttribute.fromJson(Map<String, dynamic> json) {
    return OrderItemAttribute(
      id: json['id'],
      attributeValueId: json['attributeValueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributeValueId': attributeValueId,
    };
  }
}
