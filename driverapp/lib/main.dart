// import 'package:device_preview/device_preview.dart';
import 'package:driverapp/home/home_screen.dart';
import 'package:driverapp/registration/login_screen.dart';
import 'package:driverapp/registration/register_screen.dart';
import 'package:driverapp/server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_widgets/colors.dart';
import 'registration/terms_conditions_screen.dart';

void main() {
  runApp(
    MyApp(),
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(),
    // ),
  );
}

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    bool isFirst = prefs.getBool('driverfirstuse') ?? true;
    print("$isFirst ${prefs.getBool('driverfirstuse')}");
    if (isFirst) {
      print("Show T&C");
      //Go to Terms and Conditions only once
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TermsAndConditions(),
        ),
      );
      await prefs.setBool('driverfirstuse', false);
    } else {
      bool tcAccepted = prefs.getBool('Drivert&cAccepted') ?? false;
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
          homePage: HomeScreen(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
