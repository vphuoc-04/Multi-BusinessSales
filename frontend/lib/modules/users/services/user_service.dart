import 'dart:convert';

// Repositories
import 'package:frontend/modules/users/auth/auth.dart';

// Models
import 'package:frontend/modules/users/models/user.dart';

// Auth
import 'package:frontend/modules/users/repositories/user_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

class UserService {
  final UserRepository userRepository = UserRepository();

  final Auth auth = Auth();

  // Add new user
  Future<Map<String, dynamic>> add(
    int catalogueId,
    String firstName,
    String middleName,
    String lastName,
    String email,
    String phone,
    String password
  ) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception("Token is null. Please log in again.");
    }

    try {
      final response = await userRepository.add(catalogueId, firstName, middleName, lastName, email, phone, password, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data add: $data");
        return data; 

      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return add(catalogueId, firstName, middleName, lastName, email, phone, password);
        } else {
          print("Refresh token failed. Logging out completely.");
        }

        print("Add user failed with status: ${response.body}");
      }
      
      return {
        'success': false,
        'message': 'Add user failed!'
      };

    } catch (error) {
      print("Add user failed: $error");
      throw Exception("Error: $error");
    }
  }

  // Fetch user info by catalogue data
  Future<List<User>> fetchUsersByCatalogue(int catalogueId) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userRepository.get(catalogueId, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> usersList = data['data']['content'];

        print("Users list: $usersList");

        return usersList.map((user) => User.fromJson(user)).toList();
        
      } else if (response.statusCode == 401) {
        print("Token expired during request. Attempting to refresh token...");

        bool refreshToken = await auth.refreshToken();

        if (refreshToken) {
          return fetchUsersByCatalogue(catalogueId);
        } else {
          print("Refresh token failed. Logging out completely.");
          throw Exception("Refresh token failed, please log in again.");
        }

      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to load user data!');
      }
    } catch (error) {
      throw Exception('An error occurred while fetching users data!');
    }
  }

  // Edit user
  Future<Map<String, dynamic>> edit(
    int id,
    int catalogueId,
    String firstName,
    String middleName,
    String lastName,
    String email,
    String phone,
    String password, 
  ) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception("Token is null. Please log in again.");
    }

    try {
      final response = await userRepository.edit(id, catalogueId, firstName, middleName, lastName, email, phone, password, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data add: $data");
        return data; 

      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return edit(id, catalogueId, firstName, middleName, lastName, email, phone, password);
        } else {
          print("Refresh token failed. Logging out completely.");
        }

        print("Edit user failed with status: ${response.body}");
      }
      
      return {
        'success': false,
        'message': 'Add user failed!'
      };

    } catch (error) {
      print("Add user failed: $error");
      throw Exception("Error: $error");
    }
  }

  // Delete user
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userRepository.delete(id, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data delete: $data");
        
        return data;
      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

      bool refreshToken = await auth.refreshToken(); 
        if (refreshToken) {
          return delete(id);
        } else {
          print("Refresh token failed. Logging out completely.");
        }
      }

      print("Delete user failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Delete group failed!'
      };

    } catch (error) {
      print("Delete user failed: $error");
      throw Exception("Error: $error");
    }
  }
}