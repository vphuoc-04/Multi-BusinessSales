import 'dart:convert';
import 'package:frontend/modules/orders/repositories/order_item_repository.dart';
import 'package:frontend/tokens/token.dart';
import 'package:frontend/modules/users/auth/auth.dart';

class OrderItemService {
  final OrderItemRepository repository = OrderItemRepository();
  final Auth auth = Auth();

  Future<Map<String, dynamic>> add({
    required int orderId,
    required int productId,
    required int quantity,
    required double unitPrice,
    List<int>? attributeValueIds,
  }) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.add(
        orderId: orderId,
        productId: productId,
        quantity: quantity,
        unitPrice: unitPrice,
        attributeValueIds: attributeValueIds ?? [],
        token: token,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) {
          return add(
            orderId: orderId,
            productId: productId,
            quantity: quantity,
            unitPrice: unitPrice,
            attributeValueIds: attributeValueIds,
          );
        }
      }

      return { 'success': false, 'message': 'Add order item failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> update({
    required int id,
    required int quantity,
    required double unitPrice,
  }) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.update(id: id, quantity: quantity, unitPrice: unitPrice, token: token);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) return update(id: id, quantity: quantity, unitPrice: unitPrice);
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
      final response = await repository.delete(id: id, token: token);
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
