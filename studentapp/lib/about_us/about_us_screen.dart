import 'package:flutter/material.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/registration/terms_conditions_text.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor,
          title: Text(
            "About us",
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: backGroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(termsAndConditions),
          ),
        ),
      ),
    );
  }
}
