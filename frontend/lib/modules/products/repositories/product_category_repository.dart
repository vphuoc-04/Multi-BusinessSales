// Api
import 'package:frontend/api/api.dart';

class ProductCategoryRepository {
  final Api api = Api();

  // Add product category
  Future<dynamic> add(String name, int publish, { required String token }) {
    return api.post(
      'product_category', {
        'name': name,
        'publish': publish
      }, 
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Fetch product category
  Future<dynamic> get({ required String token}) {
    return api.get(
      'product_category',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Update product category
  Future<dynamic> update(int id, String name, int publish, { required String token }) {
    return api.put(
      'product_category/$id', {
        'name': name,
        'publish': publish
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Delete product category
  Future<dynamic> delete(int id, { required String token }) {
    return api.delete(
      'product_category/$id',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}