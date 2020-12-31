import 'package:flutter/material.dart';

class backGeolocation extends StatefulWidget {
  @override
  _backGeolocationState createState() => _backGeolocationState();
}

class _backGeolocationState extends State<backGeolocation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FlatButton(onPressed: () {}, child: Text("Gelocation"))
        ],
      ),
    );
  }
}
