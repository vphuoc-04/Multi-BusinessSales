import 'dart:convert';
import 'package:frontend/modules/orders/repositories/order_item_repository.dart';
import 'package:frontend/tokens/token.dart';
import 'package:frontend/modules/users/auth/auth.dart';

class OrderItemService {
  final OrderItemRepository repository = OrderItemRepository();
  final Auth auth = Auth();

  Future<Map<String, dynamic>> add(int orderId, int productId, int quantity, double unitPrice, List<int> attributeValueIds) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.add(orderId, productId, quantity, unitPrice, attributeValueIds, token: token);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return add(orderId, productId, quantity, unitPrice, attributeValueIds);
      }

      return { 'success': false, 'message': 'Add order item failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> update(int id, int quantity, double unitPrice) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.update(id, quantity, unitPrice, token: token);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return update(id, quantity, unitPrice);
      }

      return { 'success': false, 'message': 'Update order item failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.delete(id, token: token);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return delete(id);
      }

      return { 'success': false, 'message': 'Delete order item failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
