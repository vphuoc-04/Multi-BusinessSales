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
      final refreshToken = data['data']['refreshToken'];
      final user = data['data']['user'];

      if (token == null || refreshToken == null || user == null) {
        print("Token and data is missing");
        return {
          'success': false,
          'message': 'Missing token or user data'
        };
      }

      print("Tokenid: $token");
      print("Refresh token: $refreshToken");
      print("User id: ${user['id']}");

      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('token', token);
      await sharedPrefs.setString('refreshToken', refreshToken);
      await sharedPrefs.setInt('id', user['id']);

      return {
        'success': true,
        'token': token,
        'refreshToken': refreshToken,
        'user': {
          'id': user['id'],
          'firstName': user['firstName'],
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
        await sharedPrefs.remove('refreshToken');
        await sharedPrefs.remove('id');
        print("Logout successful.");
        return true;
      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");
        bool refreshed = await refreshToken();
        if (refreshed) {
          return await logout(); 
        } else {
          print("Refresh token failed. Logging out completely.");
          await sharedPrefs.clear();
          return false;
        }
      } else {
        print("Failed to logout: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error during logout: $error");
      return false;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? oldToken = sharedPrefs.getString('token'); 
    String? refreshToken = sharedPrefs.getString('refreshToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      print("No refresh token available.");
      return false;
    }

    try {
      final response = await authRepository.refreshToken(refreshToken);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newToken = data['token'];
        final newRefreshToken = data['refreshToken'];

        if (oldToken != null && oldToken.isNotEmpty) {
          await authRepository.blacklistToken(oldToken);
        }

        print("Old token has been added to blacklisted: $oldToken");

        await sharedPrefs.setString('token', newToken);
        await sharedPrefs.setString('refreshToken', newRefreshToken);

        print("New token after refresh: $newToken");
        print("New refresh token after refresh: $newRefreshToken");

        print("Access token refreshed successfully.");

        return true;
      } else {
        print("Failed to refresh access token: ${response.body}");
        await sharedPrefs.remove('token');
        await sharedPrefs.remove('refreshToken');
        return false;
      }
    } catch (error) {
      print("Error during token refresh: $error");
      return false;
    }
  }
}