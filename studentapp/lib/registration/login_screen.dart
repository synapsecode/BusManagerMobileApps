import 'dart:io';
import 'dart:ui';

import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/fill_Info_text_field.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/payment_alert.dart';
import 'package:studentapp/common/waiting_dialog.dart';
import 'package:studentapp/home/home_screen.dart';
import 'package:studentapp/registration/fill_info_screen.dart';
import 'package:studentapp/server.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../navigation_screen.dart';

// import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController pc = TextEditingController();

    return Scaffold(
      backgroundColor: cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   "Login",
          //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
          // ),
          SizedBox(
            height: 20.0,
          ),
          fillInfoTextField(
              controller: pc, hintName: "Enter Phone Number (Login)"),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Get OTP",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () async {
                  loaderDialog(context);
                  List logres = await login(phone: pc.value.text);
                  print("LOGRESS $logres");
                  Navigator.pop(context);
                  if (logres[0]) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginOTPScreen(
                          phone: pc.value.text,
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Login Error"),
                          content: Text(logres[1] ??
                              "An Unexpected Server Error has Occured"),
                          actions: [
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FillInfoScreen(),
                ),
              );
            },
            child: Text(
              "Do not have an Account? Register",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoginOTPScreen extends StatefulWidget {
  final String phone;

  const LoginOTPScreen({Key key, this.phone}) : super(key: key);

  @override
  _LoginOTPScreenState createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   "OTP",
          //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
          // ),
          SizedBox(
            height: 20.0,
          ),
          fillInfoTextField(hintName: "OTP Code", controller: controller),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () async {
                  waitingDialog(context);
                  bool success = await login(
                    post: true,
                    phone: widget.phone,
                    OTP: controller.value.text,
                  );
                  //Removes Waiting Dialog
                  if (success) {
                    List payStat = await checkPaymentStatus();
                    Navigator.pop(context);
                    if (payStat[0]) {
                      //Paid
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NavigationScreen(),
                        ),
                      );
                    } else {
                      if (payStat[2] == 1) {
                        //Account Lapsed
                        showExpiredDialog(context: context);
                      } else {
                        showPaymentDialog(context: context);
                      }
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Invalid OTP"),
                          content: Text(
                              "Either the OTP Duration timed out or you have provided the wrong OTP"),
                          actions: [
                            FlatButton(
                              child: Text("Logout"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              loaderDialog(context);
              await resendOTP(widget.phone);
              Navigator.pop(context);
              Toast.show("OTP Sent", context, duration: 3);
            },
            child: Text(
              "Resend OTP",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
