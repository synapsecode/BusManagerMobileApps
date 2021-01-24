import 'package:flutter/material.dart';

import 'colors.dart';

loaderDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20,
            ),
            Text("Please Wait"),
          ],
        ),
      );
    },
  );
}
