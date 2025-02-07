import 'dart:convert';

// Repositoires
import 'package:frontend/modules/users/repositories/user_catalogue_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Model
import 'package:frontend/modules/users/models/user_catalogue.dart';

class UserCatalogueService {
  final UserCatalogueRepository userCatalogueRepository = UserCatalogueRepository();

  final Auth auth = Auth();

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

        bool refreshToken = await auth.refreshToken(); 
        if (refreshToken) {
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

  // Fetch user catalogue data
  Future<List<UserCatalogue>> fetchUserCatalogue() async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userCatalogueRepository.get(token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> userCataloguesList = data['data']['content'];

        print("User catalogue list: $userCataloguesList");

        return userCataloguesList
            .map((catalogue) => UserCatalogue.fromJson(catalogue))
            .toList();
            
      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

        bool refreshToken = await auth.refreshToken(); 

        if (refreshToken) {
          return fetchUserCatalogue();
        } else {
          print("Refresh token failed. Logging out completely.");
          throw Exception("Refresh token failed, please log in again.");
        }

      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to load user catalogue data!');
      }
    } catch (error) {
      throw Exception('An error occurred while fetching user catalogue data!');
    }
  }

  // Update user catalogue
  Future<Map<String, dynamic>> update(int id, String name, int publish) async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await userCatalogueRepository.update(id, name, publish, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data update: $data");
        
        return data;
      } else {
        print("Update group failed with status: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Update group failed!'
        };
      }
    } catch (error) {
      print("Update group failed: $error");
      throw Exception("Error: $error");
    }
  }
}