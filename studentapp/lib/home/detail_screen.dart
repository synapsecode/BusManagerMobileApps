import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studentapp/common/colors.dart';

class DetailScreen extends StatelessWidget {
  final String yearOfExpr;
  final String bussNumber;
  final String workLocation;
  final String name;
  final String driverImage;

  DetailScreen(
      {@required this.name,
      @required this.bussNumber,
      @required this.workLocation,
      @required this.yearOfExpr,
      @required this.driverImage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cardColor,
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: Offset(0, 57), // changes position of shadow
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.45,
              child: Hero(
                tag: driverImage,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: driverImage,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
              child: Container(
                height: 380,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18, left: 22),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      customDivider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Expr: ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(yearOfExpr,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      customDivider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bus Number: ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(bussNumber,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      customDivider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Work Location: ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(workLocation,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      customDivider(),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.black),
                              ),
                              color: cardColor,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
}
