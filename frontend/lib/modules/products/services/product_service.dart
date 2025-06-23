import 'dart:convert';
import 'dart:io';

// Repositories
import 'package:frontend/modules/products/models/product.dart';
import 'package:frontend/modules/products/repositories/product_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

class ProductService {
  final ProductRepository productRepository = ProductRepository();
  final Auth auth = Auth();

  // Add product
  Future<Map<String, dynamic>> add({
    required String productCode,
    required int productCategoryId,
    required String name,
    required double price,
    int? brandId,
    List<File>? images,
  }) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productRepository.add(
        productCode,
        productCategoryId,
        name,
        price,
        brandId,
        images,
        token: token,
      );

      print("Full Response from API: $response");

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else if (response['status'] == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return add(
            productCode: productCode,
            productCategoryId: productCategoryId,
            name: name,
            price: price,
            brandId: brandId,
            images: images,
          );
        }
      }

      return {
        'success': false,
        'message': response['message'] ?? 'Add product failed!',
      };
    } catch (error) {
      print("Error: $error");
      return {
        'success': false,
        'message': 'Lỗi khi gửi request: ${error.toString()}',
      };
    }
  }

  // Fetch products
  Future<List<Product>> fetchProducts() async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productRepository.getAll(token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> products = data['data']['content'];
        
        return products.map((product) => Product.fromJson(product)).toList();
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchProducts();
        }
      }
      throw Exception('Failed to load products!');
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  // Fetch product by categoryId
  Future<List<Product>> fetchProductByCategory(int categoryId) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productRepository.getByCategoryId(categoryId, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> products = data['data']['content'];
        
        return products.map((product) => Product.fromJson(product)).toList();
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchProducts();
        }
      }
      throw Exception('Failed to load products!');
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  // Fetch product by categoryId
  Future<List<Product>> fetchProductByName(String name) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productRepository.getProductByName(name, token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> products = data['data']['content'];
        
        return products.map((product) => Product.fromJson(product)).toList();
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchProducts();
        }
      }
      throw Exception('Failed to load products!');
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  // Update product
  Future<Map<String, dynamic>> update({
    required int id,
    required String productCode,
    required int productCategoryId,
    required String name,
    required double price,
    int? brandId,
    List<File>? images,
  }) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productRepository.update(
        id,
        productCode,
        productCategoryId,
        name,
        price,
        brandId,
        images,
        token: token,
      );

      print("Full Response from Repository: $response");

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else if (response['status'] == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return update(
            id: id,
            productCode: productCode,
            productCategoryId: productCategoryId,
            name: name,
            price: price,
            brandId: brandId,
            images: images,
          );
        }
      }
      return {
        'success': false,
        'message': response['message'] ?? 'Update product failed!',
      };
    } catch (error) {
      print("Error in update: $error");
      return {
        'success': false,
        'message': 'Error: $error',
      };
    }
  }

  // Delete product
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await productRepository.delete(id, token: token);

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return delete(id);
        }
      }
      return {'success': false, 'message': 'Delete product failed!'};
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}