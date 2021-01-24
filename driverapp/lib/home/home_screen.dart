import 'package:driverapp/common_widgets/alert_dialog.dart';
import 'package:driverapp/common_widgets/colors.dart';
import 'package:driverapp/common_widgets/fill_Info_text_field.dart';
import 'package:driverapp/common_widgets/loader.dart';
import 'package:driverapp/registration/login_screen.dart';
import 'package:driverapp/server.dart';
import 'package:flutter/material.dart';

import '../edit_profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _studentIdController = TextEditingController();
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 170.0,
            ),
            Text(
              "Allow \nStudent",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: fillInfoTextField(
                  controller: _studentIdController, hintName: "Student ID"),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Check",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                    onPressed: () async {
                      loaderDialog(context);
                      bool allowed = await allowStudent(
                        studentID: _studentIdController.value.text,
                        errorDialogBuilder: (message) {
                          return AlertDialog(
                            title: Text("Allow Student Error"),
                            content: Text(message),
                            actions: [
                              FlatButton(
                                child: Text("Close"),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          );
                        },
                      );
                      Navigator.pop(context);
                      showAlertDialogs(context, allowed);
                    }),
              ),
            ),
            OutlineButton(
              onPressed: () async {
                print(currentDriver);
                loaderDialog(context);
                await logoutDriver();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
              child: Text("Edit Profile"),
            )
          ],
        ),
      ),
    );
  }
}
