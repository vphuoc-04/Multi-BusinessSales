import 'dart:convert';

// Repositories
import 'package:frontend/modules/permissions/repositories/permission_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Model
import 'package:frontend/modules/permissions/models/permission.dart';

class PermissionService {
  final PermissionRepository permissionRepository = PermissionRepository();
  final Auth auth = Auth();

  // Add permission
  Future<Map<String, dynamic>> add({
    required String name,
    required int publish,
    required int userId,
    required String description,
  }) async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await permissionRepository.add(name, publish, userId, description, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data add: $data");
        return data;
      } else if (response.statusCode == 401) {
        print("Token expired during operation. Attempting to refresh token...");
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return add(
            name: name, 
            publish: publish, 
            userId: userId, 
            description: description
          );
        } else {
          print("Refresh token failed. Logging out completely.");
        }
      }

      print("Add permission failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Add permission failed!',
      };
    } catch (error) {
      print("Add permission failed: $error");
      throw Exception("Error: $error");
    }
  }

  // Fetch permissions
  Future<List<Permission>> fetchPermissions() async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await permissionRepository.get(token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> permissionsList = data['data']['content'];

        print("Permissions list: $permissionsList");

        return permissionsList.map((permission) => Permission.fromJson(permission)).toList();
      } else if (response.statusCode == 401) {
        print("Token expired during operation. Attempting to refresh token...");
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchPermissions();
        } else {
          print("Refresh token failed. Logging out completely.");
          throw Exception("Refresh token failed, please log in again.");
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to load permissions data!');
      }
    } catch (error) {
      throw Exception('An error occurred while fetching permissions data!');
    }
  }

  // Update permission
  Future<Map<String, dynamic>> update({
    required int id,
    required String name,
    required int publish,
    required int userId,
    required String description,
  }) async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await permissionRepository.update(id, name, publish, userId, description, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data update: $data");
        return data;
      } else if (response.statusCode == 401) {
        print("Token expired during operation. Attempting to refresh token...");
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return update(
            id: id, 
            name: name,
            publish: publish, 
            userId: userId, 
            description: description
          );
        } else {
          print("Refresh token failed. Logging out completely.");
        }
      }

      print("Update permission failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Update permission failed!',
      };
    } catch (error) {
      print("Update permission failed: $error");
      throw Exception("Error: $error");
    }
  }

  // Delete permission
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await permissionRepository.delete(id, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data delete: $data");
        return data;
      } else if (response.statusCode == 401) {
        print("Token expired during operation. Attempting to refresh token...");
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return delete(id);
        } else {
          print("Refresh token failed. Logging out completely.");
        }
      }

      print("Delete permission failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Delete permission failed!',
      };
    } catch (error) {
      print("Delete permission failed: $error");
      throw Exception("Error: $error");
    }
  }
}