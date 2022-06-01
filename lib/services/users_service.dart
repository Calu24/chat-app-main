import 'package:chatear_app/global/environment.dart';
import 'package:chatear_app/models/users_response.dart';
import 'package:chatear_app/services/auth.dart';
import 'package:http/http.dart' as http;

import 'package:chatear_app/models/users.dart';

class UsersService {
  Future <List<User>> getUsers() async{

    try {

      var url = Uri.parse('${Environment.apiUrl}/users');

      final resp = await http.get(url, 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final usersResponse = usersResponseFromJson(resp.body);

      return usersResponse.users;

    } catch (e) {
      return [];
    }
  }
}