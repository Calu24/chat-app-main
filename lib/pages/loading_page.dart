import 'package:chatear_app/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatear_app/services/auth.dart';

import '../services/socket_service.dart';

// ignore: use_key_in_widget_constructors
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLoadingState(context),
          builder: (context, snapshot) {
            return const Center(child: Text('Loading...'));
          }),
    );
  }

  Future checkLoadingState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final authenticated = await authService.isLoggedIn();

    if (authenticated) {
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsersPage(),
              transitionDuration: const Duration(seconds: 2),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );

                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              }));
    } else {
      Navigator.popAndPushNamed(context, 'login');
    }
  }
}
