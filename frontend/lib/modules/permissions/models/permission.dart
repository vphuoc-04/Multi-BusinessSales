import 'dart:convert';

class Permission {
  final int id;
  final int addedBy;
  final int editedBy;
  final String name;
  final String description;
  final int userId;
  final int publish;
  final DateTime createdAt;
  final DateTime updatedAt;

  Permission({
    required this.id,
    required this.addedBy,
    required this.editedBy,
    required this.name,
    required this.description,
    required this.userId,
    required this.publish,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] ?? 0,
      addedBy: json['addedBy'] ?? 0,
      editedBy: json['editedBy'] ?? 0,
      name: decodeUtf8(json['name'] ?? ''),
      description: decodeUtf8(json['description'] ?? ''),
      userId: json['userId'] ?? 0,
      publish: json['publish'] ?? 0,
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
      'description': description,
      'userId': userId,
      'publish': publish,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }

  @override
  String toString() {
    return 'Permission{id: $id, name: $name, description: $description, userId: $userId, publish: $publish}';
  }
}