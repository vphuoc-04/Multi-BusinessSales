class ProductImage {
  final int id;
  final int addedBy;
  final int editedBy;
  final String imageUrl;
  final int productId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductImage({
    required this.id,
    required this.addedBy,
    required this.editedBy,
    required this.imageUrl,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      addedBy: json['addedBy'] ?? 0,
      editedBy: json['editedBy'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      productId: json['product']['id'] ?? 0, 
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedBy': addedBy,
      'editedBy': editedBy,
      'imageUrl': imageUrl,
      'productId': productId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
