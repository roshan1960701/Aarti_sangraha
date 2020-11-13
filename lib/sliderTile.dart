import 'package:flutter/material.dart';

class sliderTile extends StatelessWidget {
  String imagePath, title, desc;

  sliderTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          // SizedBox(
          //   height: 5,
          // ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          // SizedBox(),
          Text(desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
        ],
      ),
    );
  }
}
