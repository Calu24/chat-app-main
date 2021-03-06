import 'package:chatear_app/global/constants.dart';
import 'package:flutter/material.dart';

class CustomElevatedBtnBlue extends StatelessWidget {
  final String btnName;
  final Function()? onPressed;

  const CustomElevatedBtnBlue({
    Key? key,
    required this.btnName,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(2),
          backgroundColor: MaterialStateProperty.all(customOrange),
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
