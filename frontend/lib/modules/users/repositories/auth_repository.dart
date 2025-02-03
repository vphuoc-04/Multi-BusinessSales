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

  // Blacklisted token
  Future<dynamic> blacklistToken(String token) {
    return api.post(
      'auth/blacklisted_token',
      {'token': token},
      headers: {
        'Authorization': 'Bearer $token'
      },
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

  // Refresh token
  Future<dynamic> refreshToken(String refreshToken) {
    return api.post(
      'auth/refresh_token', {
        'refreshToken': refreshToken
      }
    );
  }
}