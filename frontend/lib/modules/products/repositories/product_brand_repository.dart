// Api
import 'package:frontend/api/api.dart';

class ProductBrandRepository {
  final Api api = Api();

  // Add product brand
  Future<dynamic> add(String name, { required String token }) {
    return api.post(
      'product_brand', {
        'name': name
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Update product brand
  Future<dynamic> update(int id, String name, { required String token }) {
    return api.put(
      'product_brand/$id', {
        'name': name
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Fetch product brand
  Future<dynamic> get({ required String token }) {
    return api.get(
      'product_brand', 
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  Future<dynamic> delete(int id, { required String token }) {
    return api.delete(
      'product_brand/$id',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}