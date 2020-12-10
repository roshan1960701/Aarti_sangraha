import 'package:flutter/material.dart';

class listWheel extends StatefulWidget {
  @override
  _listWheelState createState() => _listWheelState();
}

class _listWheelState extends State<listWheel> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
          child: Scaffold(
        body: ListWheelScrollView(
          itemExtent: 100,
          diameterRatio: 1,
          offAxisFraction: -0.9,
          // useMagnifier: true,
          magnification: 2.5,
          children: [
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Card(
              color: Colors.blueGrey,
              child: ListTile(
                focusColor: Colors.red,
                title: Text("Android"),
                leading: Icon(
                  Icons.android_rounded,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
