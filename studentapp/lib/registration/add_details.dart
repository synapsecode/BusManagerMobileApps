import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentapp/common/app_bar.dart';
import 'package:studentapp/common/fill_info_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/payment_alert.dart';
import 'package:studentapp/home/home_screen.dart';
import 'package:studentapp/navigation_screen.dart';
import 'package:studentapp/registration/waiting.dart';
import 'package:toast/toast.dart';

import '../server.dart';

enum Scheduling { partTime, fullTime }

class AddDetailsScreeen extends StatefulWidget {
  AddDetailsScreeen({Key key}) : super(key: key);

  @override
  _AddDetailsScreeenState createState() => _AddDetailsScreeenState();
}

class _AddDetailsScreeenState extends State<AddDetailsScreeen> {
  TextEditingController st = new TextEditingController();
  TextEditingController et = new TextEditingController();
  TextEditingController dobc = new TextEditingController();
  Scheduling schedule = Scheduling.fullTime;
  TextEditingController semc = new TextEditingController();

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
    return Scaffold(
      appBar: appBarApp(barName: "Additional Details"),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Timings",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: st,
                decoration: inputDecoration(hintName: "Start Timing (8:30AM)"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: et,
                decoration: inputDecoration(hintName: "End Timing (3:40PM)"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Date of Birth",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: dobc,
                decoration: inputDecoration(hintName: "(DD/MM/YYYY)"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Schedule",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Full Time Student'),
                leading: Radio(
                  value: Scheduling.fullTime,
                  groupValue: schedule,
                  onChanged: (Scheduling value) {
                    setState(() {
                      schedule = value;
                    });
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Part Time Student'),
                leading: Radio(
                  value: Scheduling.partTime,
                  groupValue: schedule,
                  onChanged: (Scheduling value) {
                    setState(() {
                      schedule = value;
                    });
                  },
                ),
              ),
              Text(
                "Semester",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: semc,
                decoration:
                    inputDecoration(hintName: "Which Semester of University?"),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Text("Add Photo"),
                      onPressed: () async {
                        await getImage();
                        loaderDialog(context);
                        bool success = await editProfileImage(_image);
                        Navigator.of(context).pop(); //Remove Loader Dialog
                        if (success) {
                          Toast.show("Added Profile Picture", context);
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
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                      ),
                      onPressed: () async {
                        print(currentStudent);
                        print([
                          st.value.text,
                          et.value.text,
                          dobc.value.text,
                          schedule == Scheduling.fullTime,
                          semc.value.text,
                        ]);

                        loaderDialog(context);
                        Map res = await addDetails(
                          dob: dobc.value.text,
                          timings: [st.value.text, et.value.text],
                          semester: semc.value.text,
                          isFullTime: schedule == Scheduling.fullTime,
                        );
                        if (res['status'] == 0) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text(res['message']),
                              );
                            },
                          );
                        } else {
                          await getStudent();
                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => WaitingArea(),
                            ),
                            (route) => false,
                          );

                          // Navigator.of(context).pushAndRemoveUntil(
                          //   MaterialPageRoute(
                          //     builder: (context) => NavigationScreen(),
                          //   ),
                          //   (route) => false,
                          // );
                        }
                      },
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
