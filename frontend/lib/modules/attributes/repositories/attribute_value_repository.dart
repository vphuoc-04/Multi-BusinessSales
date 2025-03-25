// Api
import 'package:frontend/api/api.dart';

class AttributeValueRepository {
  final Api api = Api();

    // Add attribute
  Future<dynamic> add(String value, int attributeId, { required String token }) {
    return api.post(
      'attribute_value', {
        'value': value,
        'attributeId': attributeId
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Update attribute
  Future<dynamic> update(int id, String value, int attributeId, { required String token }) {
    return api.put(
      'attribute_value/$id', {
        'value': value,
        'attributeId': attributeId
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Get attribute
  Future<dynamic> get(int attributeId, { required String token }) {
    return api.get(
      'attribute_value/$attributeId', 
      headers: {
        'Authorization': 'Bearer $token'
      } 
    );
  }

  // Delete attribute
  Future<dynamic> delete(int id, { required String token }) {
    return api.delete(
      'attribute_value$id', 
      headers: {
        'Authorization': 'Bearer $token'
      } 
    );
  }
}