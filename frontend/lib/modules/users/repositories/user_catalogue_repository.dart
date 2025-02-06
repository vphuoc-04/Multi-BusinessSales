// Api
import 'package:frontend/api/api.dart';

class UserCatalogueRepository {
  final Api api = Api();

  // Add user catalogue
  Future<dynamic> add(String name, int publish, { required String token }) {
    return api.post(
      'user_catalogue', {
        'name': name,
        'publish': publish
      }, 
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }

  // Fetch user catalogue
  Future<dynamic> get({ required String token}) {
    return api.get(
      'user_catalogue',
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}