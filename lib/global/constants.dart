import 'package:flutter/material.dart';

const backgroundColor = Colors.black;
const customOrange    = Color.fromRGBO(255, 92, 109, 1);
var customShape       = 
  BoxDecoration(
    gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromRGBO(60, 64, 73, 1),
          Color.fromRGBO(25, 28, 37, 1),
        ]),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 0.1,
        blurRadius: 7,
        offset: const Offset(-3, -3),
      ),
    ]);
