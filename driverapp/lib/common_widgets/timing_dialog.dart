import 'package:driverapp/common_widgets/fill_Info_text_field.dart';
import 'package:flutter/material.dart';

void showTimingDialog({
  BuildContext context,
  Function setState,
  List driverTimings,
}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController st = new TextEditingController();
      TextEditingController et = new TextEditingController();
      List timings = driverTimings;

      return StatefulBuilder(
        builder: (context, useState) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            title: Container(
              width: double.infinity,
              height: 80.0,
              color: Colors.black,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Add Timings",
                        style: TextStyle(color: Colors.white, fontSize: 36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ListView.builder(
                    //   physics: NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: timings.length,
                    //   itemBuilder: (context, index) {
                    //     return ListTile(
                    //         title: Text("Driver Timing ${index + 1}"),
                    //         subtitle: Text(
                    //             "${timings[index][0]} - ${timings[index][1]}"),
                    //         trailing: Padding(
                    //           padding: const EdgeInsets.only(top: 8.0),
                    //           child: IconButton(
                    //             onPressed: () {
                    //               timings.removeAt(index);
                    //               useState(() => driverTimings = timings);
                    //             },
                    //             icon: Icon(Icons.clear),
                    //           ),
                    //         ),
                    //         leading: Padding(
                    //           padding: const EdgeInsets.only(top: 8.0),
                    //           child: Icon(Icons.watch),
                    //         ));
                    //   },
                    // ),
                    for (int i = 0; i < timings.length; i++) ...[
                      ListTile(
                        title: Text("Driver Timing ${i + 1}"),
                        subtitle: Text("${timings[i][0]} - ${timings[i][1]}"),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                            onPressed: () {
                              timings.removeAt(i);
                              useState(() => driverTimings = timings);
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.watch),
                        ),
                      )
                    ],
                    fillInfoTextField(
                        controller: st, hintName: "Start Time (8:00AM)"),
                    fillInfoTextField(
                        controller: et, hintName: "End Time (3:40PM)"),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: Text(
                        "Add Timing",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        timings.add([st.value.text, et.value.text]);
                        useState(() {});
                        setState(() {
                          driverTimings = timings;
                        });
                      },
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  setState(() {
                    driverTimings = timings;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    },
  );
}
