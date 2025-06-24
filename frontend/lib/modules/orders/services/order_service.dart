import 'dart:convert';
import 'package:frontend/modules/orders/repositories/order_repository.dart';
import 'package:frontend/tokens/token.dart';
import 'package:frontend/modules/users/auth/auth.dart';

class OrderService {
  final OrderRepository orderRepository = OrderRepository();
  final Auth auth = Auth();

  Future<Map<String, dynamic>> add(int userId, double totalAmount, List<Map<String, dynamic>> items) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await orderRepository.add(userId, totalAmount, items, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Order added: $data");
        return data;
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return add(userId, totalAmount, items);
      }

      print("Add order failed: ${response.body}");
      return { 'success': false, 'message': 'Add order failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<dynamic> fetch() async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await orderRepository.get(token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['content'];
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return fetch();
      }

      throw Exception("Fetch orders failed!");
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> update(int id, String status) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await orderRepository.update(id, status, token: token);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return update(id, status);
      }

      return { 'success': false, 'message': 'Update order failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await orderRepository.delete(id, token: token);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return delete(id);
      }

      return { 'success': false, 'message': 'Delete order failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
