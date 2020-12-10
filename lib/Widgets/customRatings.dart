import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class customRatings extends StatefulWidget {
  @override
  _customRatingsState createState() => _customRatingsState();
}

class _customRatingsState extends State<customRatings> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ratings☆☆☆"),
      content: RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          allowHalfRating: true,
          itemBuilder: (context, _) => Icon(
                Icons.favorite_rounded,
                color: Colors.amber,
              ),
          onRatingUpdate: (rating) {
            print(rating);
          }),
      actions: [
        FlatButton(onPressed: null, child: Text("Submit")),
        FlatButton(onPressed: null, child: Text("Close")),
      ],
    );
  }
}
