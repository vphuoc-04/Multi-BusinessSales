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

      if (data['user'] == null) {
        print("Data is null.");
        return {
          'success': false,
          'message': 'Invalid response structure.',
        };
      } 

      final token = data['token'];
      final user = data['user'];

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
}