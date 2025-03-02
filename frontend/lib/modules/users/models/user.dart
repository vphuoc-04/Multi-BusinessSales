import 'dart:convert';

class User {
  final int id;
  final int addedBy;
  final int? editedBy;
  final int catalogueId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String img;

  User({
    required this.id,
    required this.addedBy,
    this.editedBy,
    required this.catalogueId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.img,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      addedBy: json['addedBy'] ?? 0,
      editedBy: json['editedBy'],
      catalogueId: json['catalogueId'] ?? 0,
      firstName: decodeUtf8(json['firstName']),
      middleName: decodeUtf8(json['middleName']),
      lastName: decodeUtf8(json['lastName']),
      email: decodeUtf8(json['email']),
      phone: decodeUtf8(json['phone']),
      password: decodeUtf8(json['password']),
      img: decodeUtf8(json['img']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedBy': addedBy,
      'editedBy': editedBy,
      'catalogueId': catalogueId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'img': img,
    };
  }

  static String decodeUtf8(dynamic value) {
    if (value == null) return '';
    return utf8.decode(value.toString().codeUnits);
  }
}
