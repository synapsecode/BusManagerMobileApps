// import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studentapp/home/home_screen.dart';
import 'package:studentapp/navigation_screen.dart';
import 'package:studentapp/registration/fill_info_screen.dart';
import 'package:studentapp/registration/login_screen.dart';
import 'package:studentapp/registration/terms_conditions_screen.dart';
import 'package:studentapp/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/colors.dart';
import 'common/gredient_background_color.dart';

void main() {
  runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(),
      // ),
      MyApp());
}
// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Origin(),
    );
  }
}

class Origin extends StatefulWidget {
  Origin({Key key}) : super(key: key);

  @override
  _OriginState createState() => _OriginState();
}

class _OriginState extends State<Origin> {
  @override
  void initState() {
    super.initState();
    initLoader();
  }

  initLoader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirst = prefs.getBool('studentfirstuse') ?? true;
    print("$isFirst ${prefs.getBool('studentfirstuse')}");
    if (isFirst) {
      print("Show T&C");
      //Go to Terms and Conditions only once
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TermsAndConditions(),
        ),
      );
      await prefs.setBool('studentfirstuse', false);
    } else {
      bool tcAccepted = prefs.getBool('Studentt&cAccepted') ?? false;
      if (!tcAccepted) {
        print("TCNA");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TermsAndConditions(),
          ),
        );
      } else {
        await startupSequence(
          context: context,
          loginPage: LoginScreen(),
          homePage: NavigationScreen(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.center,
            colors: [Color(whiteColor), Color(blueColor)],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
