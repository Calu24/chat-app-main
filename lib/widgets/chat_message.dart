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
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: const Color(0xff4D9EF6), borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget receiver() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 5, right: 50, left: 5),
        decoration: BoxDecoration(
            color: const Color(0xffE4E5E8), borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
