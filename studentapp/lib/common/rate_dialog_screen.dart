import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/navigation_screen.dart';
import 'package:studentapp/server.dart';
import 'package:toast/toast.dart';

showAlertDialogs(BuildContext context, String name, String license_number) {
  int rx = 0;
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text("Rate $name"),
          content: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 18),
            child: RatingBar.builder(
              initialRating: 4,
              minRating: 1,
              itemSize: 26,
              ignoreGestures: false,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber[900],
              ),
              onRatingUpdate: (rating) {
                setState(() => rx = rating.floor());
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                loaderDialog(context);
                Map res =
                    await addRating(license_number: license_number, rating: rx);
                Navigator.pop(context);
                if (res['status'] != 0) {
                  Toast.show("Added Rating!", context);
                  Navigator.of(ctx).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationScreen()));
                } else {
                  Toast.show(res['message'], context, duration: 3);
                }
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    ),
  );
}
