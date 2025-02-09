import 'dart:convert';

// Repositoires
import 'package:frontend/modules/products/repositories/product_category_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Model
import 'package:frontend/modules/products/models/product_category.dart';

class ProductCategoryService {
  final ProductCategoryRepository productCategoryRepository = ProductCategoryRepository();

  final Auth auth = Auth();

  // Add user catalogue
  Future<Map<String, dynamic>> add(String name, int publish) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productCategoryRepository.add(name, publish, token: token);

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

      print("Add category failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Add category failed!'
      };

    } catch (error) {
      print("Add product category failed: $error");
      throw Exception("Error: $error");
    }
  }

  // Fetch user catalogue data
  Future<List<ProductCategory>> fetchProductCategory() async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productCategoryRepository.get(token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> productCategory = data['data']['content'];

        print("Product category list: $productCategory");

        return productCategory
            .map((catalogue) => ProductCategory.fromJson(catalogue))
            .toList();
            
      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

        bool refreshToken = await auth.refreshToken(); 

        if (refreshToken) {
          return fetchProductCategory();
        } else {
          print("Refresh token failed. Logging out completely.");
          throw Exception("Refresh token failed, please log in again.");
        }

      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to load product category data!');
      }
    } catch (error) {
      throw Exception('An error occurred while fetching product category data!');
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
      final response = await productCategoryRepository.update(id, name, publish, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data update: $data");
        
        return data;
      } else if (response.statusCode == 401) {
        print("Token expired during logout. Attempting to refresh token...");

      bool refreshToken = await auth.refreshToken(); 
        if (refreshToken) {
          return update(id, name, publish);
        } else {
          print("Refresh token failed. Logging out completely.");
        }
      }

      print("Update category failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Update category failed!'
      };

    } catch (error) {
      print("Update category failed: $error");
      throw Exception("Error: $error");
    }
  }

  // Delete user catalogue
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();

    if (token == null) {
      print('Error: Token is null.');
      throw Exception('Token is null. Please log in again.');
    }

        try {
      final response = await productCategoryRepository.delete(id, token: token);

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

      print("Delete category failed with status: ${response.body}");

      return {
        'success': false,
        'message': 'Delete category failed!'
      };

    } catch (error) {
      print("Delete category failed: $error");
      throw Exception("Error: $error");
    }
  }
}