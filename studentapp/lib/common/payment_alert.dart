import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/dialogs.dart';
import 'package:studentapp/common/fill_info_text_field.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/common/waiting_dialog.dart';
import 'package:studentapp/constants.dart';
import 'package:studentapp/home/home_screen.dart';
import 'package:studentapp/registration/login_screen.dart';
import 'package:studentapp/server.dart';

import '../navigation_screen.dart';

// paymentDialog(BuildContext context) {
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Theme(
//           data: ThemeData(dialogBackgroundColor: backGroundColor),
//           child: Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0)),
//             //this right here
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.50,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(6),
//                       child: Text(
//                         "Please pay \$15 to 615543995 for monthly subscription",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 1.5,
//                             wordSpacing: 2,
//                             color: Colors.purple[900]),
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey,
//                       thickness: 1.5,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20,
//                         right: 20,
//                       ),
//                       child: Text(
//                         "From Which Phone No you have sent the Money?",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 1.5,
//                             wordSpacing: 2,
//                             color: Colors.black87),
//                       ),
//                     ),
//                     phoneNumberTextField(hintName: "Mobile Phone Number"),
//                     Container(
//                       width: double.infinity,
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 20,
//                           right: 20,
//                         ),
//                         child: RaisedButton(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40)),
//                             child: Text(
//                               "Verify",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             color: Colors.black,
//                             onPressed: () {
//                               waitingDialog(context);
//                               //in future instead of timer we will add bool value, like isPaid? the
//                               // admin will make it true then it will go to homeScreen. if they didn't pay
//                               // we will show them please pay again dialog
//                               Timer(Duration(seconds: 5), () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             NavigationScreen()));
//                               });
//                             }),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       });
// }

// Widget phoneNumberTextField(
//     {TextEditingController controller, String hintName}) {
//   return Padding(
//       padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
//       child: TextField(
//         keyboardType: TextInputType.number,
//         controller: controller,
//         decoration: inputDecoration(hintName: hintName),
//       ));
// }

// InputDecoration inputDecoration({String hintName}) {
//   return InputDecoration(
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(color: Colors.black)),
//       border: OutlineInputBorder(),
//       hintText: hintName,
//       hintStyle: TextStyle(color: Colors.black54));
// }

void showPaymentDialog({BuildContext context, String message = ""}) {
  showDialog(
    context: context,
    builder: (context) {
      return NeoDialog(
        topHeight: 120,
        title: "Payment Pending!",
        color: Colors.red,
        content: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            paymentText,
            style: TextStyle(fontSize: 22),
          ),
        ),
        actions: [
          // FlatButton(
          //   child: Text(
          //     "Logout",
          //     style: TextStyle(color: Colors.red),
          //   ),
          //   onPressed: () async {
          //     loaderDialog(context);
          //     await logoutStudent();
          //     Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //         builder: (context) => LoginScreen(),
          //       ),
          //       (route) => false,
          //     );
          //   },
          // ),
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
    },
  );
}

void showExpiredDialog(
    {BuildContext context, Function setState, String message = ""}) {
  showDialog(
    context: context,
    builder: (context) {
      return NeoDialog(
        topHeight: 120,
        title: "Account Expired!",
        color: Colors.red,
        content: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            expiredText,
            style: TextStyle(fontSize: 22),
          ),
        ),
        actions: [
          // FlatButton(
          //   child: Text(
          //     "Logout",
          //     style: TextStyle(color: Colors.red),
          //   ),
          //   onPressed: () async {
          //     loaderDialog(context);
          //     await logoutStudent();
          //     Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //         builder: (context) => LoginScreen(),
          //       ),
          //       (route) => false,
          //     );
          //   },
          // ),
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
    },
  );
}
