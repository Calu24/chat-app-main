import 'package:chatear_app/global/environment.dart';
import 'package:chatear_app/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  // ignore: constant_identifier_names
  Online,
  // ignore: constant_identifier_names
  Offline,
  // ignore: constant_identifier_names
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  io.Socket get socket => _socket;
  Function get emit => _socket.emit;


  void connect() async{
    
    final token = await AuthService.getToken();

    // Dart client
    _socket = io.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token
      }
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

  void disconnect(){
    _socket.disconnect();
  }

}