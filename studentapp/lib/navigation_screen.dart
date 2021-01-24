import 'package:flutter/material.dart';
import 'package:studentapp/about_us/about_us_screen.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/common/loader.dart';
import 'package:studentapp/home/home_screen.dart';
import 'package:studentapp/mydetails.dart';
import 'package:studentapp/notification/notification_screen.dart';
import 'package:studentapp/profile/profile_screen.dart';
import 'package:studentapp/registration/login_screen.dart';
import 'package:studentapp/server.dart';

import 'common/gredient_background_color.dart';

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(currentStudent);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [Color(whiteColor), Color(blueColor)],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        children: [
                          Text(
                            "Welcome ${currentStudent['name'].split(' ')[0]}",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 29,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              loaderDialog(context);
                              await logoutStudent();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          )
                        ],
                      ),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen()));
                  },
                  child: buildNavigationButton(
                      Icons.drive_eta_rounded, Colors.green, "Drivers"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NotificationScreen()));
                  },
                  child: buildNavigationButton(Icons.notification_important,
                      Colors.redAccent, "Notifications"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfileScreen()));
                    },
                    child: buildNavigationButton(
                        Icons.edit, Colors.blueAccent, "Edit Profile")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AboutUsScreen()));
                    },
                    child: buildNavigationButton(
                        Icons.info, Colors.grey, "About us")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyDetailsPage()));
                    },
                    child: buildNavigationButton(
                        Icons.person, Colors.blueAccent, "My Details")),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AboutUsScreen()));
                    },
                    child:
                        buildNavigationButton(Icons.help, Colors.grey, "Help")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationButton(IconData icon, Color color, String buttonName) {
    return Container(
      height: 150,
      width: 160,
      child: Card(
        color: cardColor,
        elevation: 2,
        shadowColor: cardColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28.0, bottom: 10),
              child: Icon(
                icon,
                size: 60,
                color: color,
              ),
            ),
            Text(buttonName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ))
          ],
        ),
      ),
    );
  }
}
