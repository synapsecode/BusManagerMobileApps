import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:studentapp/DataModel/driver_info_model.dart';
import 'package:studentapp/common/app_bar.dart';
import 'package:studentapp/common/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:studentapp/common/rate_dialog_screen.dart';
import 'package:studentapp/home/detail_screen.dart';
import 'package:studentapp/home/home_tile.dart';
import 'package:studentapp/server.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: appBarApp(barName: "Drivers"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 18),
            child: Text("Available Drivers at your location",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    letterSpacing: 3.3,
                    fontWeight: FontWeight.w800)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, bottom: 28, top: 18),
            child: Row(
              children: [
                Text(
                  "My ID: ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey),
                ),
                Text(
                  "${currentStudent['student_id']}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.9),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 28.0, bottom: 28),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Timings: ",
          //         style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.w800,
          //             color: Colors.grey),
          //       ),
          //       Text(
          //         "${currentStudent['timings'][0]}",
          //         style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.w800,
          //             letterSpacing: 1.9),
          //       ),
          //       Text(
          //         " - ${currentStudent['timings'][1]}",
          //         style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.w800,
          //             letterSpacing: 1.9),
          //       ),
          //     ],
          //   ),
          // ),
          FutureBuilder(
            future: getAvailableBuses(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: Container(
                      color: backGroundColor,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map driver = snapshot.data[index];
                              return GestureDetector(
                                onLongPress: () {
                                  showAlertDialogs(context, driver['name'],
                                      driver['license_number']);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DetailScreen(
                                                bussNumber:
                                                    driver['bus_number'],
                                                name: driver['name'],
                                                workLocation:
                                                    driver['location'],
                                                yearOfExpr: driver['experience']
                                                    .toString(),
                                                driverImage: driver['image'],
                                              )));
                                },
                                child: HomeTile(
                                  name: driver['name'],
                                  driverPhoto: driver['image'],
                                  rating: driver['rating'],
                                ),
                              );
                            },
                          ),
                        ],
                      )),
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
