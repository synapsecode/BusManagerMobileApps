import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeTile extends StatelessWidget {
  final String name;
  final String driverPhoto;
  final double rating;

  HomeTile({this.driverPhoto, this.name, this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: driverPhoto,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 18),
                child: RatingBar.builder(
                  initialRating: double.parse(rating.toString() ?? '0.0'),
                  minRating: 1,
                  itemSize: 20,
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber[900],
                  ),
                  onRatingUpdate: (rating) {
                    print(rating.toString());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                            margin: EdgeInsets.only(left: 24),
                            height: 62,
                            width: double.infinity,
                            child: Text(
                              name,
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
