import 'package:aarti_sangraha/Screens/onboarding_view.dart';
import 'package:aarti_sangraha/Screens/registration_view.dart';
import 'package:aarti_sangraha/Screens/splashScreen_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  myApp({Key key}) : super(key: key);

  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aarti Sangraha',
      home: registration_view(),
    );
  }
}
