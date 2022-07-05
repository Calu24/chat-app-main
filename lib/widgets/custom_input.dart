import 'package:chatear_app/global/constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput(
      {Key? key,
      required this.icon,
      required this.placeHolder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPassword = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            border: Border.all(color: customOrange, width: 0.5),
            borderRadius: BorderRadius.circular(30),
            ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          controller: textController,
          autocorrect: false,
          keyboardType: keyboardType,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: placeHolder,
            hintStyle: const TextStyle(color: Colors.grey)
          ),
        ));
  }
}
