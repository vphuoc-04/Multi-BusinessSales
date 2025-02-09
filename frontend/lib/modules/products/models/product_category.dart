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
      name: json['name'] ?? '', 
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
}