import 'dart:io';

import 'package:driverapp/common_widgets/app_bar.dart';
import 'package:driverapp/common_widgets/colors.dart';
import 'package:driverapp/common_widgets/fill_Info_text_field.dart';
import 'package:driverapp/common_widgets/loader.dart';
import 'package:driverapp/common_widgets/timing_dialog.dart';
import 'package:driverapp/common_widgets/waiting_dialog.dart';
import 'package:driverapp/home/home_screen.dart';
import 'package:driverapp/registration/login_screen.dart';
import 'package:driverapp/server.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import './registration/register_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List locations = [];

  @override
  void initState() {
    super.initState();
    getLocations().then((x) => setState(() => locations = x));
  }

  TextEditingController nc = TextEditingController(text: currentDriver['name']);
  TextEditingController pc =
      TextEditingController(text: currentDriver['phone_number']);
  TextEditingController bnc =
      TextEditingController(text: currentDriver['bus_number']);
  TextEditingController lnc =
      TextEditingController(text: currentDriver['license_number']);
  TextEditingController expc =
      TextEditingController(text: currentDriver['experience'].toString());
  TextEditingController locc =
      TextEditingController(text: currentDriver['location']);

  List driverTimings = currentDriver['timings'] ?? [];

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
                        onPressed: () async {
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
                            bool success = await editProfile(
                              name: nc.value.text,
                              phone: pc.value.text,
                              busNumber: bnc.value.text,
                              licenseNumber: lnc.value.text,
                              experience: expc.value.text,
                              location: locc.value.text,
                              timings: driverTimings,
                            );

                            if (!success) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Profile Update Error"),
                                    content: Text(
                                        "An Unexpected Error Occured. Please Try Again Later."),
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
                            } else {
                              print(currentDriver);
                              if (pc.value.text !=
                                  currentDriver['phone_number']) {
                                Navigator.of(context).pop();
                                //Phone Number has Changed, Re-Verify Phone Number
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VerifyChangedPhoneNumber(
                                      phone: pc.value.text,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                await getDriver();
                                Navigator.of(context).pop();
                                Toast.show("Updated Profile!", context,
                                    duration: 3);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Update Profile Image",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
                        onPressed: () async {
                          await getImage();
                          loaderDialog(context);
                          bool success = await editProfileImage(_image);
                          Navigator.of(context).pop(); //Remove Loader Dialog
                          if (success) {
                            Toast.show("Updated Profile Picture", context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text(
                                    "Unexpected Error Occured. Could not upload Image.",
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyChangedPhoneNumber extends StatefulWidget {
  final String phone;

  const VerifyChangedPhoneNumber({Key key, this.phone}) : super(key: key);

  @override
  _VerifyChangedPhoneNumberState createState() =>
      _VerifyChangedPhoneNumberState();
}

class _VerifyChangedPhoneNumberState extends State<VerifyChangedPhoneNumber> {
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
                  bool success = await verifyDriverPhone(
                    widget.phone,
                    controller.value.text,
                  );
                  //Removes Waiting Dialog

                  if (success) {
                    currentDriver['phone_number'] = widget.phone;
                    await getDriver();
                    Navigator.pop(context);
                    Toast.show("New Phone Number Verified", context,
                        duration: 3);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen(),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
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
