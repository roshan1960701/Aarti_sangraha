import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/drawer.dart';
import 'package:flutter/material.dart';

class favouriteAarti_view extends StatefulWidget {
  favouriteAarti_view({Key key}) : super(key: key);

  @override
  _favouriteAarti_viewState createState() => _favouriteAarti_viewState();
}

class _favouriteAarti_viewState extends State<favouriteAarti_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => home_view()));
            }),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Text("favourite Aarti"),
    );
  }
}
