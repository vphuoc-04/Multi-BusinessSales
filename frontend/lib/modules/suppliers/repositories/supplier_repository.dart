// Api
import 'package:frontend/api/api.dart';

class SupplierRepository {
  final Api api = Api();

  // Add new supplier
  Future<dynamic> add (String name, { required String token }) {
    return api.post(
      'supplier', {
        'name': name
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Update supplier
  Future<dynamic> update (int id, String name, { required String token }) {
    return api.put(
      'supplier/$id', {
        'name': name
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Fetch supplier
  Future<dynamic> get ({ required String token }) {
    return api.get(
      'supplier',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  } 

  // Delete supplier
  Future<dynamic> delete (int id, { required String token }) {
    return api.delete(
      'supplier/$id', 
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}