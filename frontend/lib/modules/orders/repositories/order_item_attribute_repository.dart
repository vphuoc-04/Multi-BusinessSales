import 'package:frontend/api/api.dart';

class OrderItemAttributeRepository {
  final Api api = Api();

  Future<dynamic> add(int orderItemId, int attributeValueId, { required String token }) {
    return api.post('order_item_attributes', {
      'orderItemId': orderItemId,
      'attributeValueId': attributeValueId
    }, headers: {
      'Authorization': 'Bearer $token'
    });
  }

  Future<dynamic> update(int id, int attributeValueId, { required String token }) {
    return api.put('order_item_attributes/$id', {
      'attributeValueId': attributeValueId
    }, headers: {
      'Authorization': 'Bearer $token'
    });
  }

  Future<dynamic> delete(int id, { required String token }) {
    return api.delete('order_item_attributes/$id', headers: {
      'Authorization': 'Bearer $token'
    });
  }
}
