import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chatear_app/global/environment.dart';

import 'package:chatear_app/models/login_response.dart';
import 'package:chatear_app/models/users.dart';

class AuthService with ChangeNotifier {
  
  User? user;
  bool _authenticating = false;
  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;
  set authenticating(bool value){
    _authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async{
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');    
    return token;
  }

  static Future<void> deleteToken() async{
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');    
  }

  Future<bool> login (String email, String password) async{

    authenticating = true;

    var url = Uri.parse('${Environment.apiUrl}/login');

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post(url, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    authenticating = false;

    // print(resp.body);
    if (resp.statusCode == 200) {

      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;      

      await _saveToken(loginResponse.token);

      return true;
    }
    else{
      return false;
    }
  }

  Future register(String name, String email, String password) async{
    authenticating = true;

    var url = Uri.parse('${Environment.apiUrl}/login/new');

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final resp = await http.post(url, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    authenticating = false;

    // print(resp.body);
    if (resp.statusCode == 200) {

      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;      

      await _saveToken(loginResponse.token);

      return true;
    }
    else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];

    }
  }

  Future<bool> isLoggedIn() async{

    var url = Uri.parse('${Environment.apiUrl}/login/rebuild');

    final token = await _storage.read(key: 'token');

    final resp = await http.get(url, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      }
    );

    // print(resp.body);
    if (resp.statusCode == 200) {

      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;      

      await _saveToken(loginResponse.token);

      return true;
    }
    else{
       
      _logout();
      return false;
    }
  }

  Future _saveToken(String token) async{

    return await _storage.write(key: 'token', value: token);

  }

  Future _logout()async{

    return await _storage.delete(key: 'token');

  }
  
}