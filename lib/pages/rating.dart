import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class rating extends StatefulWidget {
  @override
  _ratingState createState() => _ratingState();
}

class _ratingState extends State<rating> {
  static var rating = 0.0;

  double getRating(){
    return rating;
  }



  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      borderColor: Colors.white,
      color: Colors.white,
      rating: rating,
      size: 40,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      defaultIconData: Icons.star_border,
      starCount: 5,
      allowHalfRating: false,
      spacing: 2.0,
      onRatingChanged: (value) {
        setState(() {
          rating = value;
        });
      },
    );
  }
}