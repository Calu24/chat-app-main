import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static late SharedPreferences _prefs;

  static String _key = '';

  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }

  static String get chatMessageJson {
    return _prefs.getString('chat$_key') ?? '';
  }

  static set chatMessageJson(String chat){
    _prefs.setString('chat$_key', chat);
  }

  static set keyPrefs(String key){
    _key = key;
  }
  
}