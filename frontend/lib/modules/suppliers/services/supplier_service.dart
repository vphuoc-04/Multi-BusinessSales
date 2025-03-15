import 'dart:convert';

// Repositories
import 'package:frontend/modules/suppliers/repositories/supplier_repository.dart';

// Tokens
import 'package:frontend/tokens/token.dart';

// Auth
import 'package:frontend/modules/users/auth/auth.dart';

// Model
import 'package:frontend/modules/suppliers/models/supplier.dart';

class SupplierService {
  final SupplierRepository supplierRepository = SupplierRepository();
  final Auth auth = Auth();

  // Add supplier
  Future<Map<String, dynamic>> add(String name) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }
    try {
      final response = await supplierRepository.add(name, token: token);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return add(name);
        } else {
          throw Exception("Refresh token failed, please log in again.");
        }
      }
      return {'success': false, 'message': 'Add supplier failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Fetch suppliers
  Future<List<Supplier>> fetchSuppliers() async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }
    try {
      final response = await supplierRepository.get(token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> suppliers = data['data']['content'];
        return suppliers.map((supplier) => Supplier.fromJson(supplier)).toList();
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return fetchSuppliers();
        } else {
          throw Exception("Refresh token failed, please log in again.");
        }
      }
      throw Exception('Failed to load suppliers!');
    } catch (error) {
      throw Exception('Error fetching suppliers: $error');
    }
  }

  // Update supplier
  Future<Map<String, dynamic>> update(int id, String name) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }
    try {
      final response = await supplierRepository.update(id, name, token: token);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return update(id, name);
        } else {
          throw Exception("Refresh token failed, please log in again.");
        }
      }
      return {'success': false, 'message': 'Update supplier failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  // Delete supplier
  Future<Map<String, dynamic>> delete(int id) async {
    String? token = await Token.loadToken();
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }
    try {
      final response = await supplierRepository.delete(id, token: token);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        bool refreshToken = await auth.refreshToken();
        if (refreshToken) {
          return delete(id);
        } else {
          throw Exception("Refresh token failed, please log in again.");
        }
      }
      return {'success': false, 'message': 'Delete supplier failed!'};
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}
