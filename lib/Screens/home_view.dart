import 'package:aarti_sangraha/Screens/aartList_view.dart';
import 'package:aarti_sangraha/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aarti_sangraha/Model/databaseHelper.dart';

class home_view extends StatefulWidget {
  home_view({Key key}) : super(key: key);

  @override
  _home_viewState createState() => _home_viewState();
}

class _home_viewState extends State<home_view> {
  final firestoreInstance = FirebaseFirestore.instance;
  final dbhelper = databaseHelper.instance;
  // startTime() async {
  //   var duration = new Duration(seconds: 6);
  //   return new Timer(duration, route);
  // }

  // route() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => registration_view()));
  // }
  Future<QuerySnapshot> getImages() async {
    if (QuerySnapshot != null) {
      return firestoreInstance.collection("Gods").get();
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Warninig"),
            );
          });
    }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    //insertData();
    //queryall();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Column(
              children: [
                IconButton(icon: Icon(Icons.search), onPressed: () {})
              ],
            )
          ],
        ),
        drawer: drawer(),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: getImages(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Image.network(
                                      snapshot.data.docs[index].data()["image"],
                                      width: 120.0,
                                      height: 120.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      snapshot.data.docs[index].data()["name"],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => aartiList_view()));
                            },
                          );
                        });
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return CircularProgressIndicator();
                    // return Center(
                    //     child: showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return AlertDialog(
                    //             title: Text("Warninig"),
                    //           );
                    //         }));
                  }
                } catch (Exception) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Please check your Internet Connection"),
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
              }),
        ),
      ),
    );
  }
}
