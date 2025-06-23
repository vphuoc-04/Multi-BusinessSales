import 'package:frontend/api/api.dart';

class PermissionRepository {
  final Api api = Api();

  // Add permission
  Future<dynamic> add(String name, int publish, int userId, String description, {required String token}) {
    return api.post(
      'permissions', {
        'name': name,
        'publish': publish,
        'userId': userId,
        'description': description,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Fetch permissions
  Future<dynamic> get({required String token}) {
    return api.get(
      'permissions',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Update permission
  Future<dynamic> update(int id, String name, int publish, int userId, String description, {required String token}) {
    return api.put(
      'permissions/$id', {
        'name': name,
        'publish': publish,
        'userId': userId,
        'description': description,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Delete permission
  Future<dynamic> delete(int id, {required String token}) {
    return api.delete(
      'permissions/$id',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}