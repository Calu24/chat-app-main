import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String title;
  final String buttonTxt;

  const Labels({
    Key? key,
    required this.route,
    required this.title,
    required this.buttonTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300)),
        const SizedBox(height: 10),
        GestureDetector(
          child: Text(buttonTxt,
              style: TextStyle(
                  color: Colors.blue[600], fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pushReplacementNamed(context, route);
          },
        ),
      ],
    );
  }
}
