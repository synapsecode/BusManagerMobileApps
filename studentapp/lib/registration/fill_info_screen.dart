import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentapp/common/app_bar.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/dialogs.dart';
import 'package:studentapp/common/fill_info_text_field.dart';
import 'package:studentapp/common/gredient_background_color.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/waiting_dialog.dart';
import 'package:studentapp/navigation_screen.dart';
import 'package:studentapp/registration/add_details.dart';
import 'package:studentapp/registration/login_screen.dart';
import 'package:studentapp/server.dart';
import 'package:toast/toast.dart';

class FillInfoScreen extends StatefulWidget {
  @override
  _FillInfoScreenState createState() => _FillInfoScreenState();
}

class _FillInfoScreenState extends State<FillInfoScreen> {
  TextEditingController nc = TextEditingController();
  TextEditingController pc = TextEditingController();
  TextEditingController locc = TextEditingController();
  TextEditingController homac = TextEditingController();
  TextEditingController uninamec = TextEditingController();
  TextEditingController uniaddrc = TextEditingController();
  List locations = [];
  List universities = [];
  List uniAddr = [];

  @override
  void initState() {
    super.initState();
    getSuggestions();
  }

  getSuggestions() async {
    List locx = await getLocations();
    print("Got Locations");
    setState(() => locations = locx);
    print("Recieved Locations => $locx");

    List unix = await getUniversities();
    print("Got Universities");
    List u = [];
    List r = [];
    unix.forEach((e) {
      u.add(e['uni_name']);
      r.add(e['uni_address']);
    });
    setState(() => universities = u);
    setState(() => uniAddr = r);
    print("Recieved University Names => $u");
    print("Recieved University Addresses => $r");
  }

  checkServiceValidity(String loc, String uni_name, String uni_address) {
    if (!locations.contains(loc) &&
        !universities.contains(uni_name) &&
        !uniAddr.contains(uni_address)) {
      Navigator.pop(context);
      showServiceUnavailableDialog(
        context: context,
        message:
            "Unfortunately, We do not provide our services to the combination of your location and university",
      );
      //  showServiceUnavailableDialog
    } else if (!locations.contains(loc)) {
      Navigator.pop(context);
      showServiceUnavailableDialog(
        context: context,
        message:
            "Unfortunately, We do not provide our services to your specified location",
      );
    } else if (!universities.contains(uni_name)) {
      Navigator.pop(context);
      showServiceUnavailableDialog(
        context: context,
        message:
            "Unfortunately, We do not provide our services to your specific University",
      );
    } else if (!uniAddr.contains(loc)) {
      Navigator.pop(context);
      showServiceUnavailableDialog(
        context: context,
        message:
            "Unfortunately, We do not provide our services to your specific Univeristy Address",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.center,
            colors: [Color(whiteColor), Color(blueColor)],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Scaffold(
            appBar: appBarApp(barName: "Registration"),
            backgroundColor: Colors.transparent,
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
                      fillInfoTextField(controller: nc, hintName: "Name"),
                      fillInfoTextField(controller: pc, hintName: "Phone No"),
                      // fillInfoTextField(controller: pc, hintName: "Student ID"),

                      suggestionTextInfoField(
                        controller: locc,
                        suggestions: locations,
                        hint: "Location (Region)",
                      ),

                      fillInfoTextField(
                          controller: homac, hintName: "Home Address"),

                      suggestionTextInfoField(
                        controller: uninamec,
                        suggestions: universities,
                        hint: "University Name",
                      ),
                      suggestionTextInfoField(
                        controller: uniaddrc,
                        suggestions: uniAddr,
                        hint: "University Address",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 28.0, vertical: 7),
                      //     child: RaisedButton(
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5)),
                      //       child: Text(
                      //         "Add Details",
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       color: Colors.green,
                      //       onPressed: () async {
                      //         showAddDetailsDialog(
                      //           context: context,
                      //           setState: setState,
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 7),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.black,
                            onPressed: () async {
                              String loc = locc.value.text;
                              String uni_name = uninamec.value.text;
                              String uni_address = uniaddrc.value.text;

                              loaderDialog(context);

                              await getSuggestions();

                              if (!locations.contains(loc) ||
                                  !universities.contains(uni_name) ||
                                  !uniAddr.contains(uni_address)) {
                                //All Combinations Not Possible
                                checkServiceValidity(
                                    loc, uni_name, uni_address);
                              } else {
                                //All Clear
                                Map res = await registerStudent(
                                  name: nc.value.text,
                                  phone: pc.value.text,
                                  homeAddress: homac.value.text,
                                  location: locc.value.text,
                                  universityAddress: uniaddrc.value.text,
                                  universityName: uninamec.value.text,
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
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Toast.show(
                                      "OTP Sent. Please Verify Phone Number",
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
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )),
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
          Text(
            "Verify Phone",
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
          ),
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
                  bool success = await verifyStudentPhone(
                    widget.phone,
                    controller.value.text,
                  );
                  print(currentStudent);
                  Navigator.pop(context); //Removes Waiting Dialog

                  if (success) {
                    Toast.show("Account Verified", context, duration: 3);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddDetailsScreeen(),
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
