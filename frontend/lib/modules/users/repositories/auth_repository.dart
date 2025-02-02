import 'package:frontend/api/api.dart';

class AuthRepository {
  final Api api = Api();

  // Login
  Future<dynamic> login(String email, String password) {
    return api.post(
      'auth/login', {
        'email': email,
        'password': password
      }
    );
  }

  // Logout
  Future<dynamic> logout(String token) {
    return api.get(
      'auth/logout',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}