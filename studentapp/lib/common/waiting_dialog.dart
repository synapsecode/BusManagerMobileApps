import 'package:flutter/material.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/fill_info_text_field.dart';

waitingDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(dialogBackgroundColor: backGroundColor),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //this right here
            child: Container(
              height: MediaQuery.of(context).size.height * 0.50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                      child: Text(
                        "Please wait while we verifying...",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            wordSpacing: 2,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
