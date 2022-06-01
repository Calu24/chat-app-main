import 'package:flutter/material.dart';

class ElevatedBtnBlue extends StatelessWidget {
  final String btnName;
  final Function()? onPressed;

  const ElevatedBtnBlue({
    Key? key,
    required this.btnName,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(2),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          shape: MaterialStateProperty.all(const StadiumBorder()),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(btnName,
                style: const TextStyle(color: Colors.white, fontSize: 19)),
          ),
        ));
  }
}
