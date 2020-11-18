import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class aartiList_view extends StatefulWidget {
  var value;
  aartiList_view({Key key, this.value}) : super(key: key);

  @override
  _aartiList_viewState createState() => _aartiList_viewState(value);
}

class _aartiList_viewState extends State<aartiList_view> {
  var value;
  var id;
  _aartiList_viewState(this.value);

  final firestoreInstance = FirebaseFirestore.instance;
  final firestoreInstanceSecond = FirebaseFirestore.instance;
  var title, img;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getArtiSangraha();
    //ganeshAarti();
    //insertData();
    //queryall();
  }

  // Future<QuerySnapshot> getArtiSangraha() async {
  //   firestoreInstance.collection("Aartis").get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((result) {
  //       //print(result.data());
  //       //print(result.data()["id"]);
  //       if (result.data()["id"] == value) {
  //         getListOfAarti();
  //       }
  //     });
  //   });
  // }

  // Future<QuerySnapshot> getListOfAarti() async {
  //   firestoreInstance
  //       .collection("Aartis")
  //       .get()
  //       .then((value) => value.docs.forEach((element) {
  //             title = element.data()["title"];
  //             img = element.data()["image"];
  //             // print(element.data()["title"]);
  //           }));
  // }

  Future<QuerySnapshot> getAartis() async {
    if (QuerySnapshot != null) {
      return firestoreInstanceSecond
          .collection("Aartis")
          .where("category", arrayContains: value)
          .get();
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Check Your Internet Connection"),
            );
          });
    }

    // .then((value) => value.docs.forEach((element) {
    //       title = element.data()["name_marathi"];
    //       img = element.data()["image"];
    //       print(title);
    //       print(img);
    //       print(element.id);
    //     }));
  }

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
        body: FutureBuilder(
          future: getAartis(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                  Colors.blue[100],
                                  Colors.green[100]
                                ])),
                            child: ListTile(
                              leading: Image.network(
                                  snapshot.data.docs[index].data()["image"]),
                              title: Text(
                                snapshot.data.docs[index]
                                    .data()["name_marathi"],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            )),
                      ),
                      onTap: () async {
                        var docID = snapshot.data.docs[index].id;
                       // print(docID);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    specificAarti_view(id: docID)));
                      },
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
