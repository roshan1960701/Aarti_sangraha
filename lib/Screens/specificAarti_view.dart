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
            Padding(
                padding: EdgeInsets.all(20.0),
                child: FutureBuilder(
                    future: getImages(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 20.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [
                                          0.2,
                                          0.4,
                                          0.6,
                                          0.8
                                        ],
                                        colors: [
                                          Colors.orange[800],
                                          Colors.pink,
                                          Colors.purple,
                                          Colors.blue
                                        ]),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Image.network(
                                          snapshot.data.docs[index]
                                              .data()["image"],
                                          width: 120.0,
                                          height: 120.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          snapshot.data.docs[index]
                                              .data()["name"],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
                        return Text("No data");
                      }
                    }))
          ],
        )),
      ),
    );
  }
}
