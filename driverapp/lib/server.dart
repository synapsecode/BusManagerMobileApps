import 'dart:io';

import 'package:driverapp/common_widgets/neodialog.dart';
import 'package:driverapp/registration/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'common_widgets/loader.dart';

Map currentDriver = {
  'id': null,
  'session_key': null,
  'name': null,
  'phone_number': null,
  'bus_number': null,
  'license_number': null,
  'experience': null,
  'rating': null,
  'image': null,
  'phone_verified': null,
  'verified': null,
  'location': null,
  'timings': null,
};

Map<String, String> get authHeader =>
    {'Session-Key': currentDriver['session_key']};

String serverURL = "https://busmanagerapi.herokuapp.com";

startupSequence({
  BuildContext context,
  Widget loginPage,
  Widget homePage,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sessionKey = prefs.getString('driver_session_key') ?? null;
  String phone = prefs.getString('driver_phone') ?? null;
  print("SP: $sessionKey $phone");
  if (phone == null || sessionKey == null) {
    //First Time Usage => LoginPage
    print("No Saved State");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => loginPage),
    );
  } else {
    currentDriver['session_key'] = sessionKey;
    currentDriver['phone_number'] = phone;
    print("CD: $currentDriver");
    bool sessionActive = await checkSession();
    if (sessionActive) {
      //AutoLogin
      print("Active Session");
      await getDriver(); //Populate Current Student Data
      bool verified = await checkVerificationStatus();
      if (verified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homePage),
        );
      } else {
        /*
      	* Show Toast that not verified
      	* logout
      	*/
        Toast.show('Logged Out. Account Not Verified', context);
        await logoutDriver();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false,
        );
        print("Driver not Verified");
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return NeoDialog(
        //         topHeight: 120,
        //         title: "Verification Pending!",
        //         color: Colors.red,
        //         content: Container(
        //           padding: EdgeInsets.all(20),
        //           child: Text(
        //             "We have noticed that your account has not yet been verified by the administrator. You cannot use the app as a driver until you have been verified. Please reopen the application after verification",
        //             style: TextStyle(fontSize: 22),
        //           ),
        //         ),
        //         actions: [
        //           FlatButton(
        //             child: Text(
        //               "Logout",
        //               style: TextStyle(color: Colors.red),
        //             ),
        //             onPressed: () async {
        //               loaderDialog(context);
        //               await logoutDriver();
        //               Navigator.of(context).pushAndRemoveUntil(
        //                 MaterialPageRoute(
        //                   builder: (context) => LoginScreen(),
        //                 ),
        //                 (route) => false,
        //               );
        //             },
        //           ),
        //           FlatButton(
        //             child: Text(
        //               "Exit",
        //               style: TextStyle(color: Colors.red),
        //             ),
        //             onPressed: () {
        //               exit(0);
        //             },
        //           )
        //         ],
        //       );
        //     });
      }
    } else {
      print("Inactive Session");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => loginPage),
      );
    }
  }
}

//Checks if the User has an Active Session
checkSession() async {
  String phone = currentDriver['phone_number'];
  String sessionKey = currentDriver['session_key'];
  final response = await http.get("$serverURL/checksession/$phone/$sessionKey");
  // print(response.body);
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

getDriver() async {
  // print("GetDriver: $currentDriver");
  if (currentDriver['phone_number'] != null &&
      currentDriver['session_key'] != null) {
    final response = await http.get(
      '$serverURL/driver/getdriver/${currentDriver['phone_number']}',
      headers: authHeader,
    );
    // print([authHeader, response.statusCode, response.body]);
    if (response.statusCode == 200) {
      Map res = json.decode(response.body);
      if (res['status'] == 200) {
        String skey = currentDriver['session_key'];
        currentDriver = res['driver'];
        print(res['driver']);
        currentDriver['session_key'] = skey;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("Saving Data to Shared Prefs");
        await prefs.setString('driver_session_key', skey);
        await prefs.setString('driver_phone', currentDriver['phone_number']);
      }
    }
  }
}

resendOTP(String phone) async {
  await http.get("$serverURL/driver/resend_otp/$phone");
}

//Verify the drivers Phone
verifyDriverPhone(String phone, String otp) async {
  final response = await http.get(
    "$serverURL/driver/verifyphone/$phone/$otp",
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) return true;
    if (res['status'] == 220) {
      print("SessionKey: ${res['session_key']}");
      currentDriver['session_key'] = res['session_key'];
      currentDriver['phone_number'] = phone;
      print("Getting Driver Details");
      await getDriver();
      return true;
    }
  }
  return false;
}

//Logout
logoutDriver() async {
  await http.get("$serverURL/driver/logout/${currentDriver['phone_number']}");
  currentDriver = {
    'id': null,
    'session_key': null,
    'name': null,
    'phone_number': null,
    'bus_number': null,
    'license_number': null,
    'experience': null,
    'rating': null,
    'image': null,
    'phone_verified': null,
    'verified': null,
    'location': null,
    'timings': null,
  };
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('driver_phone', null);
  await prefs.setString('driver_session_key', null);
}

register({
  name,
  phone,
  bus_number,
  location,
  license_number,
  experience,
  timings,
}) async {
  Map payload = {
    "name": name,
    "phone_number": phone,
    "bus_number": bus_number,
    "location": location,
    "license_number": license_number,
    "experience": experience,
    "timings": timings, //[[08:30AM, 3:30PM], [9:40AM, 4:30PM]]
  };
  final response = await http.post(
    '$serverURL/driver/register',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
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
      '$serverURL/driver/login/$phone',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'otp': OTP}),
    );
    if (response.statusCode == 200) {
      Map res = json.decode(response.body);
      if (res['status'] == 200) {
        print("SessionKey: ${res['session_key']}");
        currentDriver['session_key'] = res['session_key'];
        currentDriver['phone_number'] = phone;

        print("Getting driver Details with $currentDriver");
        await getDriver();
        return true;
      }
    }
    return false;
  }
  final res = await http.get('$serverURL/driver/login/$phone');
  if (res.statusCode == 200) {
    Map resp = json.decode(res.body);
    if (resp['status'] == 200) {
      return [true, 'OK'];
    }
    return [false, resp['message']];
  }
}

allowStudent({String studentID, Function errorDialogBuilder}) async {
  final response = await http.post(
    '$serverURL/driver/allow_student',
    headers: {
      ...authHeader,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        'student_id': studentID,
        'license_number': currentDriver['license_number'],
      },
    ),
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 0) {
      errorDialogBuilder(res['message']);
      return false;
    } else {
      return true;
    }
  }
}

editProfile({
  name,
  phone,
  busNumber,
  location,
  licenseNumber,
  experience,
  timings,
}) async {
  Map payload = {
    "id": currentDriver['id'],
    "name": name ?? currentDriver['name'],
    "phone_number": phone ?? currentDriver['phone_number'],
    "bus_number": busNumber ?? currentDriver['bus_number'],
    "location": location ?? currentDriver['location'],
    "license_number": licenseNumber ?? currentDriver['license_number'],
    "experience": experience ?? currentDriver['experience'],
    "timings": timings ?? currentDriver['timings']
  };
  final resp = await http.post(
    '$serverURL/driver/edit_profile',
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

editProfileImage(pFile) async {
  String url =
      "$serverURL/driver/update_profile_image/${currentDriver['phone_number']}";
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

checkVerificationStatus() async {
  final response = await http.get(
    "$serverURL/driver/checkverificationstatus/${currentDriver['phone_number']}",
    headers: authHeader,
  );
  if (response.statusCode == 200) {
    Map res = json.decode(response.body);
    if (res['status'] == 200) {
      return res['isVerified'];
    }
    print(res);
    return false;
  } else
    print(response.body);
  return false;
}
