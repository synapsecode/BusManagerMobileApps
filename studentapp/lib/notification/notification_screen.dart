import 'package:flutter/material.dart';
import 'package:studentapp/common/colors.dart';
import 'package:studentapp/server.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future notifications;
  @override
  void initState() {
    super.initState();
    notifications = getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: backGroundColor,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return notificationCard(
                  notificationMessage: snapshot.data[index]['message'],
                  notifiedTime: snapshot.data[index]['timeago'],
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      // body: ListView(
      //   children: [
      //     notificationCard(
      //         notificationMessage: "Bus will arrive in 5 minutes ",
      //         notifiedTime: "1 hour ago"),
      //     notificationCard(
      //         notificationMessage: "Bus will arrive in 15 minutes ",
      //         notifiedTime: "2 hour ago"),
      //     notificationCard(
      //         notificationMessage: "Bus will arrive in 25 minutes ",
      //         notifiedTime: "3 hour ago"),
      //   ],
      // ),
    );
  }

  Widget notificationCard({String notificationMessage, String notifiedTime}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        height: 80,
        child: Card(
          color: backGroundColor,
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 16),
                child: Text(
                  notificationMessage,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12),
                child: Text(
                  notifiedTime,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
