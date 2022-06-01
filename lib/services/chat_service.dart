import 'package:chatear_app/models/messages_response.dart';
import 'package:chatear_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chatear_app/models/users.dart';

import '../global/environment.dart';

class ChatService with ChangeNotifier {

  late User userDestination;

  Future<List<Message>> getChat(String userId) async{


    var url = Uri.parse('${Environment.apiUrl}/messages/$userId');

      final resp = await http.get(url, 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final messagesResp = messagesResponseFromJson(resp.body);

      return messagesResp.messages;
  }
  
}