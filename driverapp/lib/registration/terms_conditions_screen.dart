import 'dart:io';

import 'package:driverapp/common_widgets/app_bar.dart';
import 'package:driverapp/common_widgets/colors.dart';
import 'package:driverapp/common_widgets/loader.dart';
import 'package:driverapp/registration/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'terms_conditions_text.dart';

class TermsAndConditions extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      body: CreateAgreement(),
    );
  }
}

class CreateAgreement extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
        child: new Scaffold(
            appBar: new AppBar(
              leading: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Accept T&C"),
                          content: Text(
                              "You have to accep the terms and conditions to use this App"),
                          actions: [
                            FlatButton(
                              child: Text("Exit"),
                              onPressed: () {
                                exit(0);
                              },
                            ),
                            FlatButton(
                              child: Text("Agree"),
                              onPressed: () async {
                                loaderDialog(context);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('Drivert&cAccepted', true);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FillInfoScreen(),
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      });
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              elevation: 1,
              backgroundColor: cardColor,
              centerTitle: true,
              title: const Text(
                'Agreement',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                new FlatButton(
                    onPressed: () async {
                      loaderDialog(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('Drivert&cAccepted', true);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FillInfoScreen()));
                    },
                    child: new Text('AGREE',
                        style: TextStyle(color: Colors.black))),
              ],
            ),
            backgroundColor: cardColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(termsAndConditions),
              ),
            )));
  }
}
