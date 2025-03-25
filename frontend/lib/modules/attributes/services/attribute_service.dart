import 'dart:convert';

// Repositories
import 'package:frontend/modules/attributes/models/attribute.dart';
import 'package:frontend/modules/attributes/repositories/attribute_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

class AttributeService {
  final AttributeRepository attributeRepository = AttributeRepository();
  final Auth auth = Auth();

  // Add attribute
  Future<Map<String, dynamic>> add(String name) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeRepository.add(name, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return add(name);
        }
      }
      return {'success': false, 'message': 'Add attribute failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Update attribute
  Future<Map<String, dynamic>> update(int id, String name) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeRepository.update(id, name, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return update(id, name);
        }
      }
      return {'success': false, 'message': 'Update attribute failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Fetch attributes
  Future<List<Attribute>> fetchAttributes() async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeRepository.get(token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> attributes = data['data'];

        return attributes.map((attribute) => Attribute.fromJson(attribute)).toList();
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchAttributes();
        }
      }
      throw Exception('Failed to load attributes!');
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  // Delete attribute
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();

    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    try {
      final response = await attributeRepository.delete(id, token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return delete(id);
        }
      }
      return {'success': false, 'message': 'Delete attribute failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}