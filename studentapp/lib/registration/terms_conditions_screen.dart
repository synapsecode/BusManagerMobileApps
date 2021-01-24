import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/gredient_background_color.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/registration/fill_info_screen.dart';

import 'terms_conditions_text.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.center,
          colors: [Color(whiteColor), Color(blueColor)],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Scaffold(
        // backgroundColor: cardColor,
        body: SafeArea(
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
                              "You have to accept the terms and conditions to use this App"),
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
                                await prefs.setBool('Studentt&cAccepted', true);
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
                      await prefs.setBool('Studentt&cAccepted', true);
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
            ),
          ),
        ),
      ),
    );
  }
}
