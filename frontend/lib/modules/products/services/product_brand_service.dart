import 'dart:convert';

// Repositories
import 'package:frontend/modules/products/repositories/product_brand_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Model
import 'package:frontend/modules/products/models/product_brand.dart';

class ProductBrandService {
  final ProductBrandRepository productBrandRepository = ProductBrandRepository();
  final Auth auth = Auth();

  // Add product brand
  Future<Map<String, dynamic>> add(String name) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productBrandRepository.add(name, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return add(name);
        }
      }
      return {'success': false, 'message': 'Add brand failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Fetch product brands
  Future<List<ProductBrand>> fetchProductBrands() async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productBrandRepository.get(token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> productBrands = data['data']['content'];
        return productBrands.map((brand) => ProductBrand.fromJson(brand)).toList();
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchProductBrands();
        }
      }
      throw Exception('Failed to load product brands!');
    } catch (error) {
      throw Exception('Error fetching product brands: $error');
    }
  }

  // Update product brand
  Future<Map<String, dynamic>> update(int id, String name) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productBrandRepository.update(id, name, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return update(id, name);
        }
      }
      return {'success': false, 'message': 'Update brand failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Delete product brand
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productBrandRepository.delete(id, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return delete(id);
        }
      }
      return {'success': false, 'message': 'Delete brand failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
