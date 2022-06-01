import 'package:flutter/material.dart';
import 'package:chatear_app/pages/loading_page.dart';
import 'package:chatear_app/pages/login_page.dart';
import 'package:chatear_app/pages/register_page.dart';
import 'package:chatear_app/pages/users_page.dart';
import 'package:chatear_app/pages/chat_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes  = {
  'users':  (_) => UsersPage(),
  'chat':  (_) => ChatPage(),
  'loading':  (_) => LoadingPage(),
  // ignore: prefer_const_constructors
  'login':  (_) => LoginPage(),
  // ignore: prefer_const_constructors
  'register':  (_) => RegisterPage(),

};