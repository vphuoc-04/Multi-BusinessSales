import 'package:frontend/api/api.dart';

class OrderRepository {
  final Api api = Api();

  Future<dynamic> add({
    required int userId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
    required String token,
  }) {
    return api.post(
      'orders',
      {
        'userId': userId,
        'totalAmount': totalAmount,
        'items': items,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<dynamic> get({
    required String token,
  }) {
    return api.get(
      'orders',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<dynamic> update({
    required int id,
    required String status,
    required String token,
  }) {
    return api.put(
      'orders/$id',
      {
        'status': status,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<dynamic> delete({
    required int id,
    required String token,
  }) {
    return api.delete(
      'orders/$id',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}
