import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/payment_alert.dart';

import '../navigation_screen.dart';
import '../server.dart';

class WaitingArea extends StatefulWidget {
  const WaitingArea({Key key}) : super(key: key);

  @override
  _WaitingAreaState createState() => _WaitingAreaState();
}

class _WaitingAreaState extends State<WaitingArea> {
  @override
  void initState() {
    super.initState();
    checkPaymentStatus().then((payStat) {
      print("DONE -> $payStat");
      if (payStat[0]) {
        //Paid
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NavigationScreen(),
          ),
          (route) => false,
        );
      } else {
        if (payStat[2] == 1) {
          //Account Lapsed
          showExpiredDialog(context: context);
        } else {
          showPaymentDialog(context: context);
        }
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
              Text("Verifying Payment"),
            ],
          ),
        ),
      ),
    );
  }
}
