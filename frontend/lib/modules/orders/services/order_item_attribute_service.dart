import 'dart:convert';
import 'package:frontend/modules/orders/repositories/order_item_attribute_repository.dart';
import 'package:frontend/tokens/token.dart';
import 'package:frontend/modules/users/auth/auth.dart';

class OrderItemAttributeService {
  final OrderItemAttributeRepository repository = OrderItemAttributeRepository();
  final Auth auth = Auth();

  Future<Map<String, dynamic>> add({
    required int orderItemId,
    required int attributeValueId,
  }) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.add(
        orderItemId: orderItemId,
        attributeValueId: attributeValueId,
        token: token,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) {
          return add(orderItemId: orderItemId, attributeValueId: attributeValueId);
        }
      }

      return { 'success': false, 'message': 'Add attribute failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> update({
    required int id,
    required int attributeValueId,
  }) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.update(
        id: id,
        attributeValueId: attributeValueId,
        token: token,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) {
          return update(id: id, attributeValueId: attributeValueId);
        }
      }

      return { 'success': false, 'message': 'Update attribute failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<Map<String, dynamic>> delete({ required int id }) async {
    String? token = await Token.loadToken();
    if (token == null) throw Exception("Token is null.");

    try {
      final response = await repository.delete(id: id, token: token);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        if (await auth.refreshToken()) {
          return delete(id: id);
        }
      }

      return { 'success': false, 'message': 'Delete attribute failed!' };
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
