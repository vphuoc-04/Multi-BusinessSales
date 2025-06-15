import 'dart:convert';
import 'dart:io';

import 'package:frontend/api/api.dart';

class ProductRepository {
  final Api api = Api();

  // Add product
  Future<Map<String, dynamic>> add(
    String productCode,
    int productCategoryId,
    String name,
    double price,
    int brandId,
    List<File>? images, {
    required String token,
  }) async {
    Map<String, String> fields = {
      'productCode': productCode,
      'productCategoryId': productCategoryId.toString(),
      'name': name,
      'price': price.toString(),
      'brandId': brandId.toString(),
    };

    print("📤 Sending Fields: $fields");
    print("🔑 Sending Token: $token");

    if (images != null && images.isNotEmpty) {
      print("Sending Images: ${images.map((e) => e.path).toList()}");
    } else {
      print("No Images Attached!");
    }

    try {
      var response = await api.multipartPost('product', fields: fields, files: images, token: token);

      var responseData = await response.stream.bytesToString();
      print("Full Response from API: $responseData");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(responseData),
        };
      } else {
        return {
          'success': false,
          'message': 'Add product failed!',
          'status': response.statusCode,
        };
      }
    } catch (error) {
      print("Error: $error");
      return {
        'success': false,
        'message': 'Lỗi khi gửi request: $error',
      };
    }
  }

  // Update product
  Future<Map<String, dynamic>> update(
    int id,
    String productCode,
    int productCategoryId,
    String name,
    double price,
    int brandId,
    List<File>? images, {
    required String token,
  }) async {
    Map<String, String> fields = {
      'productCode': productCode,
      'productCategoryId': productCategoryId.toString(),
      'name': name,
      'price': price.toString(),
      'brandId': brandId.toString(),
    };

    print("📤 Sending Fields: $fields");
    print("🔑 Sending Token: $token");

    if (images != null && images.isNotEmpty) {
      print("📸 Sending Images: ${images.map((e) => e.path).toList()}");
    } else {
      print("⚠️ No Images Attached!");
    }

    try {
      var response = await api.multipartPut('product/$id', fields: fields, files: images, token: token);

      var responseData = await response.stream.bytesToString();
      print("📩 Full Response from API: $responseData");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(responseData),
        };
      } else {
        return {
          'success': false,
          'message': 'Update product failed!',
          'status': response.statusCode,
        };
      }
    } catch (error) {
      print("Error: $error");
      return {
        'success': false,
        'message': 'Lỗi khi gửi request: $error',
      };
    }
  }


  // Fetch products
  Future<dynamic> getAll({required String token}) {
    return api.get(
      'product',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Fetch product by categoryId
  Future<dynamic> getByCategoryId(int categoryId, {required String token}) {
    return api.get(
      'product?productCategoryId=$categoryId',
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
  }

  // Get product by name
  Future<dynamic> getProductByName(String name, {required String token}) {
    return api.get(
      'product?keyword=$name',
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
  }

  // Delete product
  Future<dynamic> delete(int id, {required String token}) {
    return api.delete(
      'product/$id',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}
