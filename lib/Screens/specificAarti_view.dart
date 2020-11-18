import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';

class specificAarti_view extends StatefulWidget {
  var id;
  specificAarti_view({Key key, this.id}) : super(key: key);

  @override
  _specificAarti_viewState createState() => _specificAarti_viewState(id);
}

class _specificAarti_viewState extends State<specificAarti_view> {
  var id;
  _specificAarti_viewState(this.id);
  final firestoreInstance = FirebaseFirestore.instance;
  String aarti, image, mp3, name_marathi;

  Future<QuerySnapshot> getImages() async {
    // DocumentReference docRef = firestoreInstance.collection("Aartis").get();
    firestoreInstance.collection("Aartis").doc(id).get().then((value) => {});
    // var result = firestoreInstance.collection("Aartis").doc(id).get();
    // if (result != null) {
    //   print(result);
    // }
  }

  Future<QuerySnapshot> getSpecificAarti() async {
    firestoreInstance.collection("Aartis").doc(id).get().then((value) {
      if (value.id.length > 0) {
        setState(() {
          name_marathi = value["name_marathi"];
          aarti = value["aarti"];
          image = value["image"];
          mp3 = value["mp3"];
        });

        print(name_marathi);
        print(aarti);
        print(image);
        print(mp3);
        // var data= value.id;
        // print(data);
      }
    });

    // var result = firestoreInstance.collection("Aartis").doc(id).get();
    // if (result != null) {
    //   print(result);
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecificAarti();
    // get();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                        size: 24.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Container(
                  width: 130.0,
                  height: 130.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network('$image'))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  '$name_marathi',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.0),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    '$aarti',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      Share.share('To listen this Aarti ' +
                          '$name_marathi' +
                          ' Download the Mp3 File\n' +
                          '$mp3');
                    },
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
