import 'package:flutter/cupertino.dart';

showAlert(BuildContext context, String title, String subtitle) {
  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              CupertinoButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}
