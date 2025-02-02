import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Repositories
import 'package:frontend/modules/users/repositories/auth_repository.dart';

class Auth {
  final AuthRepository authRepository = AuthRepository();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await authRepository.login(email, password);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("Data: $data");

      if (data['data']['user'] == null) {
        print("Data is null.");
        return {
          'success': false,
          'message': 'Invalid response structure.',
        };
      } 

      final token = data['data']['token'];
      final user = data['data']['user'];

      if (token == null || user == null) {
        print("Token and data is missing");
        return {
          'success': false,
          'message': 'Missing token or user data'
        };
      }

      print("Token: $token");
      print("User id: ${user['id']}");

      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('token', token);
      await sharedPrefs.setInt('id', user['id']);

      return {
        'success': true,
        'token': token,
        'user': {
          'id': user['id']
        },
      };
    } else {
      print("Error: HTTP ${response.statusCode}");
      return {
        'success': false,
        'message': 'Unexpected error occurred.',
      };
    }
  }

  // Logout
  Future<bool> logout() async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      String? token = sharedPrefs.getString('token');

      if (token == null || token.isEmpty) {
        print("No token for logout");
        return false;
      }

      final response = await authRepository.logout(token);

      if (response.statusCode == 200) {
        await sharedPrefs.remove('token');
        await sharedPrefs.remove('id');
        print("Logout successful.");
        return true;
      } else {
        print("Failed to logout: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error during logout: $error");
      return false;
    }
  }
}