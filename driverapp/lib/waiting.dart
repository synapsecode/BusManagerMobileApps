import 'dart:async';
import 'dart:io';

import 'package:driverapp/home/home_screen.dart';
import 'package:driverapp/registration/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:driverapp/common_widgets/loader.dart';
import 'package:driverapp/common_widgets/timing_dialog.dart';

import './server.dart';
import 'common_widgets/neodialog.dart';

class WaitingArea extends StatefulWidget {
  const WaitingArea({Key key}) : super(key: key);

  @override
  _WaitingAreaState createState() => _WaitingAreaState();
}

class _WaitingAreaState extends State<WaitingArea> {
  @override
  void initState() {
    super.initState();
    checkVerificationStatus().then((isVerified) {
      if (isVerified) {
        //Paid
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return NeoDialog(
                topHeight: 120,
                title: "Verification Pending!",
                color: Colors.red,
                content: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "We have noticed that your account has not yet been verified by the administrator. You cannot use the app as a driver until you have been verified. You will be redirected once the admin has completed the verification process.",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      loaderDialog(context);
                      await logoutDriver();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Exit",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      exit(0);
                    },
                  )
                ],
              );
            });
      }
    });
    //Repeater
    Timer.periodic(Duration(seconds: 15), (timer) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WaitingArea()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Awaiting Admin Verification"),
            ],
          ),
        ),
      ),
    );
  }
}
