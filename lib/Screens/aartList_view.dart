import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var aartiName;

  Icon cusSearchIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget cusAppBar = Text("");

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
  void getSearchAartis() async {
    if (QuerySnapshot != null) {
      var result = firestoreInstance
          .collection('Aartis')
          .orderBy("name_english")
          .orderBy("name_marathi")
          .startAt(["gan raya"]).endAt(["gan raya" + "\uf88f"]).snapshots();
      print(result);
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Check Your Internet Connection"),
            );
          });
    }
  }

  Future getAarti() async {
    if (QuerySnapshot != null) {
      return Firestore.instance.collection("Aartis").snapshots();
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Check Your Internet Connection"),
            );
          });
    }
  }

  // .then((value) => value.docs.forEach((element) {
  //       title = element.data()["name_marathi"];
  //       img = element.data()["image"];
  //       print(title);
  //       print(img);
  //       print(element.id);
  //     }));

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
          actions: [
            IconButton(
                icon: cusSearchIcon,
                onPressed: () {
                  // showSearch(context: context, delegate: DataSearch());
                  setState(() {
                    if (this.cusSearchIcon.icon == Icons.search) {
                      this.cusSearchIcon = Icon(Icons.cancel);
                      this.cusAppBar = TextField(
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Aarti",
                            hintStyle: TextStyle(color: Colors.white54)),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        onChanged: (val) {
                          setState(() {
                            aartiName = val;
                          });
                        },
                        //onChanged: (query) => updateSearchQuery(query),
                      );
                    } else {
                      this.cusSearchIcon = Icon(Icons.search);
                      this.cusAppBar = Text("");
                    }
                  });
                }),
          ],
          title: cusAppBar,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: (aartiName != "" && aartiName != null)
              ? Firestore.instance
                  .collection('Aartis')
                  .orderBy("name_english")
                  .startAt([aartiName]).endAt(
                      [aartiName + "\uf88f"]).snapshots()
              : Firestore.instance
                  .collection("Aartis")
                  .where("category", arrayContains: value)
                  .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              height: 60.0,
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
                                  snapshot.data.docs[index].data()["image"],
                                  fit: BoxFit.fill,
                                ),
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
                    },
                  );
          },
        ),
        // body: FutureBuilder(
        //   future: getAartis(),
        //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (snapshot.hasData) {
        //       return ListView.builder(
        //           itemCount: snapshot.data.docs.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             return InkWell(
        //               child: Padding(
        //                 padding: const EdgeInsets.all(10.0),
        //                 child: Container(
        //                     height: 50.0,
        //                     decoration: BoxDecoration(
        //                         gradient: LinearGradient(
        //                             begin: Alignment.topLeft,
        //                             end: Alignment.bottomRight,
        //                             colors: [
        //                           Colors.blue[100],
        //                           Colors.green[100]
        //                         ])),
        //                     child: ListTile(
        //                       leading: Image.network(
        //                           snapshot.data.docs[index].data()["image"]),
        //                       title: Text(
        //                         snapshot.data.docs[index]
        //                             .data()["name_marathi"],
        //                         style: TextStyle(fontWeight: FontWeight.w700),
        //                       ),
        //                     )),
        //               ),
        //               onTap: () async {
        //                 var docID = snapshot.data.docs[index].id;
        //                 // print(docID);
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) =>
        //                             specificAarti_view(id: docID)));
        //               },
        //             );
        //           });
        //     }
        //     return Center(child: CircularProgressIndicator());
        //   },
        // ),
      ),
    );
  }
}

// class DataSearch extends SearchDelegate<String> {
//   final firestore = Firestore.instance;
//
//   final cities = [
//     "colima",
//     "monterrey",
//     "jalisco",
//     "sinaloa",
//     "cdmx",
//     "sonora",
//     "baja california",
//     "chiapa",
//     "tabasco"
//   ];
//
//   // final recentCities = [
//   //   "colima",
//   //   "monterrey",
//   //   "jalisco",
//   // ];
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     // TODO: implement buildActions
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           })
//     ];
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     // TODO: implement buildLeading
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     return Center(
//       child: Container(
//           height: 100.0,
//           width: 100.0,
//           child: Card(
//             color: Colors.red,
//             child: Center(
//               child: Text(query),
//             ),
//           )),
//     );
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     final suggestionList = cities.where((p) => p.startsWith(query)).toList();
//
//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           showResults(context);
//         },
//         title: RichText(
//             text: TextSpan(
//                 text: suggestionList[index].substring(0, query.length),
//                 style:
//                     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                 children: [
//               TextSpan(
//                   text: suggestionList[index].substring(query.length),
//                   style: TextStyle(color: Colors.grey))
//             ])),
//       ),
//       itemCount: suggestionList.length,
//     );
//     throw UnimplementedError();
//   }
// }
