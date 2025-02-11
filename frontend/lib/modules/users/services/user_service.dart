import 'dart:convert';

// Repositories
import 'package:frontend/modules/users/auth/auth.dart';

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

        print("Add group failed with status: ${response.body}");
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
}