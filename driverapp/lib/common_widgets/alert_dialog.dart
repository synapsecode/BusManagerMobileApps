import 'package:flutter/material.dart';

showAlertDialogs(BuildContext context, bool isAllowed) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => AlertDialog(
      title: isAllowed
          ? Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            )
          : Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 80,
            ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: isAllowed
              ? Text(
                  "Allow",
                  style: TextStyle(color: Colors.black),
                )
              : Text(
                  "Do not Allow",
                  style: TextStyle(color: Colors.black),
                ),
        ),
      ],
    ),
  );
}
