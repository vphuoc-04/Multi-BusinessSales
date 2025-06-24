import 'package:frontend/api/api.dart';

class OrderItemRepository {
  final Api api = Api();

  Future<dynamic> add(int orderId, int productId, int quantity, double unitPrice, List<int>? attributeValueIds, { required String token }) {
    return api.post('order_items', {
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'attributeValueIds': attributeValueIds
    }, headers: {
      'Authorization': 'Bearer $token'
    });
  }

  Future<dynamic> update(int id, int quantity, double unitPrice, { required String token }) {
    return api.put('order_items/$id', {
      'quantity': quantity,
      'unitPrice': unitPrice
    }, headers: {
      'Authorization': 'Bearer $token'
    });
  }

  Future<dynamic> delete(int id, { required String token }) {
    return api.delete('order_items/$id', headers: {
      'Authorization': 'Bearer $token'
    });
  }
}
