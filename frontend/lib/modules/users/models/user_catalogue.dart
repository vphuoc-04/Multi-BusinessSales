class UserCatalogue {
  final int id;
  final String name;
  final int publish;

  UserCatalogue({
    required this.id,
    required this.name,
    required this.publish
  });

  factory UserCatalogue.fromJson (Map<String, dynamic> json) {
    return UserCatalogue(
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