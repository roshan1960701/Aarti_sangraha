import 'package:flutter/material.dart';

class specificAarti_view extends StatefulWidget {
  specificAarti_view({Key key}) : super(key: key);

  @override
  _specificAarti_viewState createState() => _specificAarti_viewState();
}

class _specificAarti_viewState extends State<specificAarti_view> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: MaterialButton(
                    minWidth: 80.0,
                    height: 35.0,
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: null),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            )
          ],
        )),
      ),
    );
  }
}
