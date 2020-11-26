import 'dart:async';
import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/Screens/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashScreen_view extends StatefulWidget {
  splashScreen_view({Key key}) : super(key: key);

  @override
  _splashScreen_viewState createState() => _splashScreen_viewState();
}

class _splashScreen_viewState extends State<splashScreen_view> {
  completed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = (prefs.getBool('first_time') ?? false);

    var _duration = new Duration(seconds: 3);

    if (firstTime) {
      // Not first time
      return new Timer(_duration, navigationPageHome);
    } else {
      // First time
      prefs.setBool('first_time', true);
      return new Timer(_duration, navigationPageReg);
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool _seen = (prefs.getBool('seen') ?? false);
    //
    // if (_seen) {
    //   Navigator.of(context).pushReplacement(
    //       new MaterialPageRoute(builder: (context) => new home_view()));
    // } else {
    //   await prefs.setBool('seen', true);
    //   Navigator.of(context).pushReplacement(
    //       new MaterialPageRoute(builder: (context) => new registration_view()));
    // }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => registration_view()));
  }

  void navigationPageHome() async {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new home_view()));
  }

  void navigationPageReg() async {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new registration_view()));
  }

  @override
  void initState() {
    super.initState();
    completed();
    // Timer(Duration(seconds: 2), completed);
  }

  // Future checkFirstSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool _seen = (prefs.getBool('seen') ?? false);
  //
  //   if (_seen) {
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new splashScreen_view()));
  //   } else {
  //     await prefs.setBool('seen', true);
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new onboarding_view()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // checkFirstSeen();
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 20.0,
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
