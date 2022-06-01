import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      // ? 'https://chat-server-lagarto.herokuapp.com/api'
      ? 'http://10.0.2.2:3000/api'
      : 'http://localhost:3000/api';
  static String socketUrl =
      // Platform.isAndroid ? 'https://chat-server-lagarto.herokuapp.com' : 'http://localhost:3000';
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
}
