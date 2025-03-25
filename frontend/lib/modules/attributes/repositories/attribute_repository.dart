// Api
import 'package:frontend/api/api.dart';

class AttributeRepository {
  final Api api = Api();
  
    // Add attribute
  Future<dynamic> add(String name, { required String token }) {
    return api.post(
      'attribute', {
        'name': name
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Update attribute
  Future<dynamic> update(int id, String name, { required String token }) {
    return api.put(
      'attribute/$id', {
        'name': name
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Get attribute
  Future<dynamic> get({ required String token }) {
    return api.get(
      'attribute', 
      headers: {
        'Authorization': 'Bearer $token'
      } 
    );
  }

  // Delete attribute
  Future<dynamic> delete(int id, { required String token }) {
    return api.delete(
      'attribute/$id', 
      headers: {
        'Authorization': 'Bearer $token'
      } 
    );
  }
}