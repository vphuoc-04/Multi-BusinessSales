import 'dart:convert';

// Repositories
import 'package:frontend/modules/attributes/models/attribute_value.dart';
import 'package:frontend/modules/attributes/repositories/attribute_value_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

class AttributeValueService {
  final AttributeValueRepository attributeValueRepositoy = AttributeValueRepository();
  final Auth auth = Auth();

  // Add attribute value
  Future<Map<String, dynamic>> add(String value, int attributeId) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeValueRepositoy.add(value, attributeId, token: token);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response: $data");
        return data;
      } else {
        print("Error: Failed to add attribute value. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 401) {
          bool refreshToken = await auth.refreshToken();
          if (refreshToken) {
            return add(value, attributeId);
          }
        }
        return {'success': false, 'message': 'Add attribute value failed!'};
      }
    } catch (error, stackTrace) {
      print("Exception: $error");
      print("StackTrace: $stackTrace");
      return {'success': false, 'message': 'An unexpected error occurred.'};
    }
  }

  // Update attribute value
  Future<Map<String, dynamic>> update(int id, String value, int attributeId) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeValueRepositoy.update(id, value, attributeId, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print("Error: Failed to add attribute value. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return update(id, value, attributeId);
        }
      }
      }
      return {'success': false, 'message': 'Update attribute value failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Fetch attribute value by attribute
  Future<List<AttributeValue>> fetchById(int attributeId) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeValueRepositoy.get(attributeId, token: token);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("API Response: $decoded");

        final rawData = decoded['data'];

        if (rawData is List) {
          return rawData.map((item) => AttributeValue.fromJson(item)).toList();

        } else if (rawData is Map<String, dynamic>) {
          return [AttributeValue.fromJson(rawData)];

        } else {
          throw Exception('Unexpected response format: "data" is neither List nor Map');

        }
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchAttributeValues(attributeId);
        }
      }

      throw Exception('Failed to fetch attribute values!');
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Fetch attribute value by attribute
  Future<List<AttributeValue>> fetchAttributeValues(int attributeId) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeValueRepositoy.getByAttributeId(attributeId, token: token);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("API Response: $decoded");

        final rawData = decoded['data'];

        if (rawData is List) {
          return rawData.map((item) => AttributeValue.fromJson(item)).toList();

        } else if (rawData is Map<String, dynamic>) {
          return [AttributeValue.fromJson(rawData)];

        } else {
          throw Exception('Unexpected response format: "data" is neither List nor Map');

        }
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchAttributeValues(attributeId);
        }
      }

      throw Exception('Failed to fetch attribute values!');
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Delete attribute value
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeValueRepositoy.delete(id, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print("Error: Failed to delete attribute value. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return delete(id);
        }
      }
      }
      return {'success': false, 'message': 'Delete attribute value failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}