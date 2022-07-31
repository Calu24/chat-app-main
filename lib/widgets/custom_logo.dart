import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  
  final String title;
  final String subTitle;
  
  const CustomLogo({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        // width: 200,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
            Text(
              subTitle,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
