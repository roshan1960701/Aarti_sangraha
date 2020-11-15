import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:flutter/material.dart';

class aartiList_view extends StatefulWidget {
  aartiList_view({Key key}) : super(key: key);

  @override
  _aartiList_viewState createState() => _aartiList_viewState();
}

class _aartiList_viewState extends State<aartiList_view> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        ),
        body: ListView.builder(
            itemCount: 40,
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.deepPurple, Colors.greenAccent])),
                    child: Center(
                        child: Text(
                      "Hello World",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => specificAarti_view()));
                },
              );
            }),
      ),
    );
  }
}
