import 'package:aarti_sangraha/drawer.dart';
import 'package:flutter/material.dart';

class aboutUs_view extends StatefulWidget {
  aboutUs_view({Key key}) : super(key: key);

  @override
  _aboutUs_viewState createState() => _aboutUs_viewState();
}

class _aboutUs_viewState extends State<aboutUs_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: drawer(),
      body: Text("AboutUs"),
    );
  }
}
