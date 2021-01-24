import 'package:driverapp/common_widgets/app_bar.dart';
import 'package:driverapp/common_widgets/colors.dart';
import 'package:driverapp/common_widgets/fill_Info_text_field.dart';
import 'package:driverapp/common_widgets/loader.dart';
import 'package:driverapp/common_widgets/neodialog.dart';
import 'package:driverapp/common_widgets/timing_dialog.dart';
import 'package:driverapp/common_widgets/waiting_dialog.dart';
import 'package:driverapp/home/home_screen.dart';
import 'package:driverapp/registration/login_screen.dart';
import 'package:driverapp/server.dart';
import 'package:driverapp/waiting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:toast/toast.dart';

class FillInfoScreen extends StatefulWidget {
  @override
  _FillInfoScreenState createState() => _FillInfoScreenState();
}

class _FillInfoScreenState extends State<FillInfoScreen> {
  List locations = [];

  @override
  void initState() {
    super.initState();
    getLocations().then((x) => setState(() => locations = x));
  }

  TextEditingController nc = TextEditingController();
  TextEditingController pc = TextEditingController();
  TextEditingController bnc = TextEditingController();
  TextEditingController lnc = TextEditingController();
  TextEditingController expc = TextEditingController();
  TextEditingController locc = TextEditingController();
  List<List<String>> driverTimings = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: appBarApp(barName: "Registration"),
        backgroundColor: cardColor,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Card(
              color: backGroundColor,
              shadowColor: Colors.black,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   "Register",
                  //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  fillInfoTextField(controller: nc, hintName: "Name"),
                  fillInfoTextField(controller: pc, hintName: "Phone No"),
                  suggestionTextInfoField(
                    controller: locc,
                    suggestions: locations,
                    hint: "Location(Region)",
                  ),
                  fillInfoTextField(controller: bnc, hintName: "Bus Number"),

                  fillInfoTextField(
                      controller: lnc, hintName: "Licence Number"),
                  fillInfoTextField(controller: expc, hintName: "Experience"),
                  // fillInfoTextField(
                  //     controller: locc, hintName: "Location (Region)"),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Add Timings",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                        onPressed: () async {
                          showTimingDialog(
                            context: context,
                            setState: setState,
                            driverTimings: driverTimings,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 10.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
                        onPressed: () async {
                          print("Registering");
                          loaderDialog(context);
                          locations = await getLocations();
                          if (!locations.contains(locc.value.text)) {
                            Navigator.pop(context);
                            showServiceUnavailableDialog(
                              context: context,
                              message:
                                  "Unfortunately, We do not provide our services to this location",
                            );
                          } else {
                            Map res = await register(
                              name: nc.value.text,
                              phone: pc.value.text,
                              bus_number: bnc.value.text,
                              location: locc.value.text,
                              license_number: lnc.value.text,
                              experience: expc.value.text,
                              timings: driverTimings,
                            );
                            Navigator.pop(context);
                            if (res['status'] == 0) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Register Error"),
                                    content: Text(res['message']),
                                    actions: [
                                      FlatButton(
                                        child: Text("close"),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  );
                                },
                              );
                            } else {
                              Toast.show("OTP Sent. Please Verify Phone Number",
                                  context,
                                  duration: 3);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => VerifyPhoneScreen(
                                    phone: pc.value.text,
                                  ),
                                ),
                                (route) => false,
                              );
                            }
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
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showServiceUnavailableDialog({BuildContext context, String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return NeoDialog(
        title: "Service Unavailable",
        color: Colors.red,
        content: Container(
          padding: EdgeInsets.all(15),
          child: Text(message),
        ),
        topHeight: 110,
        actions: [
          FlatButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

class VerifyPhoneScreen extends StatefulWidget {
  final String phone;

  const VerifyPhoneScreen({Key key, this.phone}) : super(key: key);

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   "Verify Phone",
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
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () async {
                  waitingDialog(context);
                  bool success = await verifyDriverPhone(
                    widget.phone,
                    controller.value.text,
                  );
                  Navigator.pop(context); //Removes Waiting Dialog

                  if (success) {
                    Toast.show("Phone Number Verified", context, duration: 3);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => WaitingArea(),
                      ),
                    );
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
