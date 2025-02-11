// Api
import 'package:frontend/api/api.dart';

class UserRepository {
  final Api api = Api();

  // Add new user
  Future<dynamic> add(
    int catalogueId,
    String firstName,
    String middleName,
    String lastName,
    String email,
    String phone,
    String password, 
    { required String token }
  ){
      return api.post('add_user', {
        'catalogueId': catalogueId,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password
      },
      headers: {
        'Authorization': 'Bearer $token'
      }
    );
  }
}