import 'package:flutter/material.dart';
import 'package:studentapp/server.dart';

class MyDetailsPage extends StatefulWidget {
  MyDetailsPage({Key key}) : super(key: key);

  @override
  _MyDetailsPageState createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.yellow[100],
            ),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    "My Details",
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(height: 20.0),
                  CircleAvatar(
                    radius: 105.0,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.black12,
                      backgroundImage: NetworkImage(currentStudent['picture']),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "Name: ${currentStudent['name']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "StudentID: ${currentStudent['student_id']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Phone: ${currentStudent['phone_number']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Timings: ${currentStudent['timings'][0]} - ${currentStudent['timings'][1]}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Semester: ${currentStudent['semester']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "FullTime: ${currentStudent['isFullTime'] ? 'Yes' : 'No'}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "University Name: ${currentStudent['university_name']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Location: ${currentStudent['location']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "My Address: ${currentStudent['home_address']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "University Name: ${currentStudent['university_name']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "University Address: ${currentStudent['university_address']}",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ));
  }
}
