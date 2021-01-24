import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/fill_info_text_field.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/waiting_dialog.dart';
import 'package:studentapp/navigation_screen.dart';
import 'package:studentapp/registration/add_details.dart';
import 'package:studentapp/registration/fill_info_screen.dart';
import 'package:studentapp/server.dart';
import 'package:toast/toast.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController;
  TextEditingController _phoneNumberController;
  TextEditingController _locationController;
  TextEditingController _homeAddressController;
  TextEditingController _universityNameController;
  TextEditingController _universityAddressController;

  List locations = [];
  List universities = [];
  List uniAddr = [];

  TextEditingController st;
  TextEditingController et;
  TextEditingController dobc;
  Scheduling schedule;
  TextEditingController semc;

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
  void initState() {
    _nameController = TextEditingController(text: currentStudent['name']);
    _phoneNumberController =
        TextEditingController(text: currentStudent['phone_number']);
    _locationController =
        TextEditingController(text: currentStudent['location']);
    _homeAddressController =
        TextEditingController(text: currentStudent['home_address']);
    _universityNameController =
        TextEditingController(text: currentStudent['university_name']);
    _universityAddressController =
        TextEditingController(text: currentStudent['university_address']);
    st = TextEditingController(text: currentStudent['timings'][0] ?? 'None');
    et = TextEditingController(text: currentStudent['timings'][1] ?? 'None');
    dobc = TextEditingController(text: currentStudent['dob'] ?? 'None');
    semc = TextEditingController(text: currentStudent['semester'] ?? 'None');
    // print(currentStudent);
    schedule = (currentStudent['isFullTime'])
        ? Scheduling.fullTime
        : Scheduling.partTime;

    getSuggestions();

    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      backgroundColor: backGroundColor,
      body: ListView(
        children: [
          updateTextField(_nameController, "Name"),
          updateTextField(_phoneNumberController, "Phone Number"),
          suggestionTextInfoField(
            controller: _locationController,
            suggestions: locations,
            hint: "Location (Region)",
            isEditMode: true,
          ),
          updateTextField(_homeAddressController, "Home Address"),
          suggestionTextInfoField(
            controller: _universityNameController,
            suggestions: universities,
            hint: "University Name",
            onSelect: (suggestion) {
              int index = universities?.indexOf(suggestion) ?? -1;
              if (index != -1) {
                _universityAddressController.text = uniAddr[index];
              }
            },
            isEditMode: true,
          ),
          updateTextField(_universityAddressController, "University Address"),
          Container(
            padding: EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Column(
              children: [
                Text(
                  "Timings",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                updateTextField(st, "Start Timing"),
                SizedBox(
                  height: 10,
                ),
                updateTextField(et, "End Timing"),
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
                updateTextField(dobc, "Date of Birth (DD/MM/YYYY)"),
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Semester",
                  style: TextStyle(fontSize: 24),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                updateTextField(semc, "Semester"),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Update Photo",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
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
              ),
            ),
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
                  String s = st.value.text;
                  String e = et.value.text;

                  List timings = (s != '' && e != '') ? [s, e] : null;
                  String loc = _locationController.value.text;
                  String uni_name = _universityNameController.value.text;
                  String uni_address = _universityAddressController.value.text;

                  loaderDialog(context);

                  await getSuggestions();
                  print("$loc\n$uni_name\n$uni_address");

                  if (!locations.contains(loc) ||
                      !universities.contains(uni_name) ||
                      !uniAddr.contains(uni_address)) {
                    //All Combinations Not Possible
                    checkServiceValidity(loc, uni_name, uni_address);
                  } else {
                    bool success = await editProfile(
                      name: _nameController.value.text,
                      phone: _phoneNumberController.value.text,
                      homeAddress: _homeAddressController.value.text,
                      location: _locationController.value.text,
                      universityName: _universityNameController.value.text,
                      universityAddress:
                          _universityAddressController.value.text,
                      timings: timings,
                      dob: dobc.value.text != '' ? dobc.value.text : null,
                      semester: semc.value.text != '' ? semc.value.text : null,
                      isFullTime: schedule == Scheduling.fullTime,
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
                      print(currentStudent);
                      if (_phoneNumberController.value.text !=
                          currentStudent['phone_number']) {
                        Navigator.of(context).pop();
                        //Phone Number has Changed, Re-Verify Phone Number
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => VerifyChangedPhoneNumber(
                              phone: _phoneNumberController.value.text,
                            ),
                          ),
                          (route) => false,
                        );
                      } else {
                        await getStudent();
                        Navigator.of(context).pop();
                        Toast.show("Updated Profile!", context, duration: 3);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => NavigationScreen(),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget updateTextField(TextEditingController controller, String fieldName) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 12, bottom: 3),
            child: Text(
              fieldName,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: controller,
            decoration: inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
        suffixIcon: Icon(Icons.edit),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black)),
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.black54));
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
                  bool success = await verifyStudentPhone(
                    widget.phone,
                    controller.value.text,
                  );
                  //Removes Waiting Dialog

                  if (success) {
                    currentStudent['phone_number'] = widget.phone;
                    await getStudent();
                    Navigator.pop(context);
                    Toast.show("New Phone Number Verified", context,
                        duration: 3);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => NavigationScreen(),
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
