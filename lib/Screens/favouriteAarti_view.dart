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
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      drawer: drawer(),
      body: Text("favourite Aarti"),
    );
  }
}
