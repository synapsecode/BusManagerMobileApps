import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/payment_alert.dart';
import 'package:studentapp/registration/login_screen.dart';

Map currentStudent = {
  "session_key": null,
  "id": null,
  "name": null,
  "phone_number": null,
  "home_address": null,
  "location": null,
  "university_name": null,
  "university_address": null,
  "timings": null,
  "semester": null,
  "isFullTime": null,
  "dob": null,
  "picture": null,
};

Map<String, String> get authHeader =>
    {'Session-Key': currentStudent['session_key']};

String serverURL = "https://busmanager.loca.lt";

startupSequence({
  BuildContext context,
  Widget loginPage,
  Widget homePage,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionKey = prefs.getString('student_session_key') ?? null;
  String phone = prefs.getString('student_phone') ?? null;
  print("PREFS $sessionKey $phone");
  if (phone == null || sessionKey == null) {
    //First Time Usage => LoginPage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => loginPage),
    );
  } else {
    currentStudent['session_key'] = sessionKey;
    currentStudent['phone_number'] = phone;

    bool sessionActive = await checkSession();
    if (sessionActive) {
      //AutoLogin
      await getStudent(); //Populate Current Student Data
      List payStat = await checkPaymentStatus();
      if (payStat[0]) {
        //Paid
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homePage),
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
      //InactiveSession => LoginPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => loginPage),
      );
    }
  }
}

//Checks if the User has an Active Session
checkSession() async {
  String phone = currentStudent['phone_number'];
  String sessionKey = currentStudent['session_key'];
  final response = await http.get("$serverURL/checksession/$phone/$sessionKey");
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) {
      return res['isActive'];
    }
  }
  return false;
}

//get all the universities {'uni_name', 'uni_address'}
getUniversities() async {
  final response = await http.get('$serverURL/getuniversities');
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    return res['universities'];
  }
  return [];
}

//get all locations
getLocations() async {
  final response = await http.get('$serverURL/getlocations');
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    return res['locations'];
  }
  return [];
}

getStudent() async {
  if (currentStudent['phone_number'] != null &&
      currentStudent['session_key'] != null) {
    final response = await http.get(
      '$serverURL/student/getstudent/${currentStudent['phone_number']}',
      headers: authHeader,
    );

    if (response.statusCode == 200) {
      Map res = json.decode(response.body);
      if (res['status'] == 200) {
        String skey = currentStudent['session_key'];
        currentStudent = res['student'];
        currentStudent['session_key'] = skey;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("Saving Data to Shared Prefs");
        await prefs.setString('student_session_key', skey);
        await prefs.setString('student_phone', currentStudent['phone_number']);
      }
    }
  } else {
    print("PHONE&SESSION->EMPTY");
  }
}

//==========================================================================================
//Resend OTP to User
resendOTP(String phone) async {
  await http.get("$serverURL/student/resend_otp/$phone");
}

//Verify the Students Phone
verifyStudentPhone(String phone, String otp) async {
  final response = await http.get(
    "$serverURL/student/verifyphone/$phone/$otp",
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) return true;
    if (res['status'] == 220) {
      print("SessionKey: ${res['session_key']}");
      currentStudent['session_key'] = res['session_key'];
      currentStudent['phone_number'] = phone;
      print("Getting Student Details");
      await getStudent();
      return true;
    }
  }
  return false;
}

//Logout
logoutStudent() async {
  await http.get("$serverURL/student/logout/${currentStudent['phone_number']}");
  currentStudent = {
    "session_key": null,
    "id": null,
    "name": null,
    "phone_number": null,
    "home_address": null,
    "location": null,
    "university_name": null,
    "university_address": null,
    "timings": null,
    "semester": null,
    "isFullTime": null,
    "dob": null,
    "picture": null,
  };
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('student_phone', null);
  await prefs.setString('student_session_key', null);
}

registerStudent({
  name,
  phone,
  homeAddress,
  location,
  universityName,
  universityAddress,
}) async {
  Map payload = {
    "name": name,
    "phone_number": phone,
    "home_address": homeAddress,
    "location": location,
    "university_name": universityName,
    "university_address": universityAddress
  };
  final response = await http.post('$serverURL/student/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload));
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    return res;
  }
  return {'status': 0, 'message': 'Register Request Server Error'};
}

addDetails({dob, timings, semester, isFullTime}) async {
  Map payload = {
    "timing": timings,
    "semester": semester,
    "isFullTime": isFullTime,
    "dob": dob,
    "phone": currentStudent['phone_number']
  };
  final response = await http.post(
    '$serverURL/student/add_details',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      ...authHeader
    },
    body: jsonEncode(payload),
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    return res;
  }
  return {'status': 0, 'message': 'Register Request Server Error'};
}

login({
  OTP,
  phone,
  post = false,
}) async {
  if (post) {
    final response = await http.post(
      '$serverURL/student/login/$phone',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'otp': OTP}),
    );
    if (response.statusCode == 200) {
      Map res = json.decode(response.body);
      if (res['status'] == 200) {
        print("SessionKey: ${res['session_key']}");
        currentStudent['session_key'] = res['session_key'];
        currentStudent['phone_number'] = phone;
        print("Getting Student Details");
        await getStudent();
        return true;
      }
    }
    return false;
  }

  final res = await http.get('$serverURL/student/login/$phone');
  if (res.statusCode == 200) {
    Map resp = json.decode(res.body);
    if (resp['status'] == 200) {
      return [true, 'OK'];
    }
    return [false, resp['message']];
  }
}

getAvailableBuses() async {
  final response = await http.get(
    "$serverURL/student/get_available_buses/${currentStudent['phone_number']}",
    headers: authHeader,
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) {
      return res['drivers'];
    }
  }
  return [];
}

checkPaymentStatus() async {
  final response = await http.get(
    "$serverURL/student/checkpaymentstatus/${currentStudent['phone_number']}",
    headers: authHeader,
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) {
      return [res['isPaid'], res['message'], 200];
    }
    return [false, res['message'], res['status']];
  }
  return [false, 'Server Error', 0];
}

getMyDrivers() async {
  final response = await http.get(
    "$serverURL/student/mydrivers/${currentStudent['phone_number']}",
    headers: authHeader,
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) {
      return res['drivers'];
    }
  }
  return [];
}

editProfile({
  name,
  phone,
  homeAddress,
  location,
  universityName,
  universityAddress,
  timings,
  dob,
  isFullTime,
  semester,
}) async {
  Map payload = {
    "id": currentStudent['id'],
    "name": name ?? currentStudent['name'],
    "phone_number": phone ?? currentStudent['phone_number'],
    "home_address": homeAddress ?? currentStudent['home_address'],
    "location": location ?? currentStudent['location'],
    "university_name": universityName ?? currentStudent['university_name'],
    "university_address":
        universityAddress ?? currentStudent['university_address'],
    "timings": timings ?? currentStudent['timings'],
    "semester": semester ?? currentStudent['semester'],
    "dob": dob ?? currentStudent['dob'],
    "isFullTime": isFullTime ?? currentStudent['isFullTime'],
  };
  final resp = await http.post(
    '$serverURL/student/edit_profile',
    body: jsonEncode(payload),
    headers: {
      ...authHeader,
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (resp.statusCode == 200) {
    return true;
  }
  return false;
}

addRating({String license_number, int rating}) async {
  final response = await http.post(
    '$serverURL/driver/add_rating',
    headers: {
      ...authHeader,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        'license_number': license_number,
        'student_phone': currentStudent['phone_number'],
        'rating': rating,
      },
    ),
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    print(res);
    return res;
  }
  return {'status': 0, 'message': 'Server Error'};
}

editProfileImage(pFile) async {
  await getStudent();
  print(currentStudent);
  print(authHeader);
  String url =
      "$serverURL/student/update_profile_image/${currentStudent['phone_number']}";
  final request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(
    await http.MultipartFile.fromPath(
      'picture',
      pFile.path,
    ),
  );
  request.headers.addAll(authHeader);
  final response = await request.send();
  if (response.statusCode == 200) {
    print(response);
    return true;
  }
  print(response);
  return false;
}

getNotifications() async {
  final response = await http.get(
    "$serverURL/student/getnotifications",
    headers: authHeader,
  );
  Map res = json.decode(response.body);
  print("RESS $res");
  return res['notifications'];
}
