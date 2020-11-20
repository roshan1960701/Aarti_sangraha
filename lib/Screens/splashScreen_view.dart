import 'dart:async';
import 'package:aarti_sangraha/Screens/onboarding_view.dart';
import 'package:aarti_sangraha/Screens/registration_view.dart';
import 'package:flutter/material.dart';

class splashScreen_view extends StatefulWidget {
  splashScreen_view({Key key}) : super(key: key);

  @override
  _splashScreen_viewState createState() => _splashScreen_viewState();
}

class _splashScreen_viewState extends State<splashScreen_view> {
  void completed() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => registration_view()));
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 20.0,
          // height: 300.0,
          // width: 300.0,
          // decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: BorderRadius.all(Radius.circular(50.0)),
          //     boxShadow: [
          //       new BoxShadow(
          //         color: Colors.black38,
          //         offset: Offset(1.0, 0.0),
          //         spreadRadius: 1.0,
          //       ),
          //     ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "lib/asset/logo/logo.png",
            ),
          ),
        ),
      ),
    );
  }
}
