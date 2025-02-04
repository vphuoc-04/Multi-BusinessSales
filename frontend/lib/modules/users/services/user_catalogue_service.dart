import 'dart:convert';

// Repositoires
import 'package:frontend/modules/users/repositories/user_catalogue_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';
import 'package:frontend/tokens/auto_refresh_token.dart';

class UserCatalogueService {
  final UserCatalogueRepository userCatalogueRepository = UserCatalogueRepository();

  // Add user catalogue
  Future<Map<String, dynamic>> add(String name, int publish) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userCatalogueRepository.add(name, publish, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data add: $data");
        return data; 

      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

        final autoRefresh = AutoRefreshToken();
        bool isRefreshed = await autoRefresh.autoRefreshToken(); 
        if (isRefreshed) {
          return add(name, publish);
        } else {
          print("Refresh token failed. Logging out completely.");
        }
      }

      print("Add group failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Add group failed!'
      };

    } catch (error) {
      print("Add user catalogue failed: $error");
      throw Exception("Error: $error");
    }
  }
}