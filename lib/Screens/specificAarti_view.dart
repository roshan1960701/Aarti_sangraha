import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class specificAarti_view extends StatefulWidget {
  specificAarti_view({Key key}) : super(key: key);

  @override
  _specificAarti_viewState createState() => _specificAarti_viewState();
}

class _specificAarti_viewState extends State<specificAarti_view> {
  final firestoreInstance = FirebaseFirestore.instance;
  // Map data;
  // List<String> godsData = new List<String>();

  // void get() async {
  //   firestoreInstance.collection("Gods").get().then((value) {
  //     value.docs.forEach((element) {
  //       print(element.data());
  //     });
  //   });
  // }

  Future<QuerySnapshot> getImages() {
    return firestoreInstance.collection("Gods").get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
            ),

          ],
        )),
      ),
    );
  }
}
