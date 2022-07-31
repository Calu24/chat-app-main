import 'package:chatear_app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatear_app/services/auth.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;
  const ChatMessage({
    Key? key,
    required this.text,
    required this.uid,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == authService.user?.uid ? senderUser() : receiver(),
        ),
      ),
    );
  }

  Widget senderUser() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
          decoration: BoxDecoration(
              color: customOrange, 
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.white.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(1, 3),
                ),
                const BoxShadow(
                  color: Colors.black,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(3, 5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget receiver() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 5, right: 50, left: 5),
          decoration: BoxDecoration(
              color: Colors.black, 
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.white.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(1, 3),
                ),
                const BoxShadow(
                  color: Colors.black,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(3, 5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              )
            ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
