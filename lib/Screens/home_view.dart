import 'package:aarti_sangraha/Screens/aartList_view.dart';
import 'package:aarti_sangraha/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aarti_sangraha/Model/databaseHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class home_view extends StatefulWidget {
  home_view({Key key}) : super(key: key);

  @override
  _home_viewState createState() => _home_viewState();
}

class _home_viewState extends State<home_view> {
  final firestoreInstance = FirebaseFirestore.instance;
  final firestoreInstance1 = FirebaseFirestore.instance;
  int position;
  var value;
  var aartiSangId;
  final dbhelper = databaseHelper.instance;
  List AartiSangrahaId = new List();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  var googleID;

  // startTime() async {
  //   var duration = new Duration(seconds: 6);
  //   return new Timer(duration, route);
  // }

  // route() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => registration_view()));
  // }

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity();
    googleSignOut();
    getGoogleUid();
    super.initState();
    //getAartidSangrahaID();
    //insertData();
    //queryall();
  }

  googleSignOut() async {
    _googleSignIn.signOut();
  }

  getGoogleUid() async {
    SharedPreferences googleUid = await SharedPreferences.getInstance();
    googleID = googleUid.getString('googleUid');
    print("Google ID" + "$googleID");
  }

  Future<QuerySnapshot> getArtiSangraha() async {
    if (QuerySnapshot != null) {
      return firestoreInstance.collection("AartiSangraha").get();
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

  checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Internet Connection!!!"),
              content: Text("Please connect Internet"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"))
              ],
            );
          });
    }
  }

  Future<QuerySnapshot> getAartidSangrahaID() async {
    firestoreInstance1.collection("AartiSangraha").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        AartiSangrahaId.add(result.id);
        print(result.id);
        //print(result.data());
      });
    });
  }

  Future<dynamic> shoDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warninig"),
          );
        });
  }

  void insertData() async {
    Map<String, dynamic> row = {
      databaseHelper.columnGodName: "Ganehsa",
    };
    final id = await dbhelper.insertGod(row);
    print(id);
  }

  void queryall() async {
    var allrows = await dbhelper.allGodQuery();
    allrows.forEach((row) {
      print(row);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Column(
              children: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: aartiSearchDelegate(),
                      );
                    })
              ],
            )
          ],
        ),
        drawer: drawer(),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: getArtiSangraha(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  try {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.1,
                                        0.4,
                                        0.6,
                                        0.9
                                      ],
                                      colors: [
                                        Colors.orange[800],
                                        Colors.pink,
                                        Colors.purple,
                                        Colors.orange
                                      ]),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SafeArea(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Image.network(
                                          snapshot.data.docs[index]
                                              .data()["image"],
                                          width: 120.0,
                                          height: 120.0,
                                        ),
                                      ),
                                    ),
                                    SafeArea(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          snapshot.data.docs[index]
                                              .data()["name"],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    // Text(snapshot.data.docs[index].id)
                                  ],
                                ),
                              ),
                              onTap: () async {
                                var docId = snapshot.data.docs[index].id;
                                //print(docId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            aartiList_view(value: docId)));
                                // onPressed();
                              },
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  Text("Please check your Internet Connection"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Close",
                                      style: TextStyle(color: Colors.blue),
                                    ))
                              ],
                            );
                          });
                    }
                  } catch (Exception) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text("Please check your Internet Connection"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Close",
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
                          );
                        });
                  }

                  // try {
                  //   if (snapshot.connectionState == ConnectionState.done) {

                  //   } else if (snapshot.connectionState == ConnectionState.none) {
                  //     return CircularProgressIndicator();
                  //     // return Center(
                  //     //     child: showDialog(
                  //     //         context: context,
                  //     //         builder: (BuildContext context) {
                  //     //           return AlertDialog(
                  //     //             title: Text("Warninig"),
                  //     //           );
                  //     //         }));
                  //   }
                  // } catch (Exception) {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text("Please check your Internet Connection"),
                  //           actions: [
                  //             FlatButton(
                  //                 onPressed: () {
                  //                   Navigator.pop(context);
                  //                 },
                  //                 child: Text(
                  //                   "Close",
                  //                   style: TextStyle(color: Colors.blue),
                  //                 ))
                  //           ],
                  //         );
                  //       });
                  // }

                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}

class aartiSearchDelegate extends SearchDelegate {
  final firestoreInstance = FirebaseFirestore.instance;
  BuildContext context;

  Future<QuerySnapshot> getSearchAarti() async {
    if (QuerySnapshot != null) {
      firestoreInstance.collection('Aartis').snapshots();
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

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Container(
          height: 100.0,
          width: 100.0,
          child: Card(
            color: Colors.red,
            child: Center(
              child: Text(query),
            ),
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return StreamBuilder(
        stream: (query != "" && query != null)
            ? FirebaseFirestore.instance
                .collection('Aartis')
                .orderBy("name_english")
                .startAt([query]).endAt([query + "\uf88f"]).snapshots()
            : FirebaseFirestore.instance
                .collection("FavouriteAartis")
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                "Sorry Aarti Not Found",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
            );
          }
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
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
                  });
        });
    throw UnimplementedError();
  }
}
