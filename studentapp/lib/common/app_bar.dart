import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Widget appBarApp({String barName}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(
      barName,
      style: TextStyle(color: Colors.black, fontSize: 26),
    ),
    backgroundColor: cardColor,
    elevation: 0,
  );
}
