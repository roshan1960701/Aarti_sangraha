import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/utilities.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarti_sangraha/Screens/specificAarti_view.dart';

class favouriteAarti_view extends StatefulWidget {
  favouriteAarti_view({Key key}) : super(key: key);

  @override
  _favouriteAarti_viewState createState() => _favouriteAarti_viewState();
}

class _favouriteAarti_viewState extends State<favouriteAarti_view> {
  var aartiName;
  var id;
  final fireStoreInstance = FirebaseFirestore.instance;
  var favAartis;
  utilities util = new utilities();
  var userId;
  Icon cusSearchIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget cusAppBar = Text("");
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () {
      util.checkConnectivity(context);
    });
    checkUser();
    super.initState();
  }

  Future<String> getSpecificUserId() async {
    SharedPreferences googleUid = await SharedPreferences.getInstance();
    userId = googleUid.getString('userId');
    // print(userId);
    return userId;
  }

  checkUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    favAartis = sharedPreferences.getStringList("Fav");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFF06701), Color(0xFFFF8804)])),
                ),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => home_view()));
                    }),
                actions: [
                  IconButton(
                      icon: cusSearchIcon,
                      onPressed: () {
                        setState(() {
                          if (this.cusSearchIcon.icon == Icons.search) {
                            this.cusSearchIcon = Icon(Icons.cancel);
                            this.cusAppBar = TextField(
                              textInputAction: TextInputAction.go,
                              onChanged: (val) {
                                setState(() {
                                  aartiName = val.toLowerCase();
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Aarti",
                                  hintStyle: TextStyle(color: Colors.white54)),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                              //onChanged: (query) => updateSearchQuery(query),
                            );
                          } else {
                            this.cusSearchIcon = Icon(Icons.search);
                            this.cusAppBar = Text("");
                            aartiName = null;
                          }
                        });
                      })
                ],
                title: cusAppBar,
              ),
              body: FutureBuilder(
                  future: getSpecificUserId(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      if (userId == "SKIPID0012345") {
                        return StreamBuilder<QuerySnapshot>(
                          stream: (aartiName != "" && aartiName != null)
                              ? (aartiName
                                      .toLowerCase()
                                      .startsWith(new RegExp('[a-z]')))
                                  ? FirebaseFirestore.instance
                                      .collection("Aartis")
                                      .orderBy("name_english")
                                      .startAt([aartiName]).endAt(
                                          [aartiName + "\uf88f"]).snapshots()
                                  : FirebaseFirestore.instance
                                      .collection("Aartis")
                                      .orderBy("name")
                                      .startAt([aartiName]).endAt(
                                          [aartiName + "\uf88f"]).snapshots()
                              : FirebaseFirestore.instance
                                  .collection("Aartis")
                                  .where(FieldPath.documentId,
                                      whereIn: favAartis.toList())
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  "Sorry Aarti Not Found",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            } else {
                              return (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // DocumentSnapshot data =
                                        //     snapshot.data.docs[index];
                                        return InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 10.0,
                                                right: 10.0),
                                            child: Container(
                                                height: 60.0,
                                                child: Card(
                                                  elevation: 10.0,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          child: Image.network(
                                                              snapshot.data
                                                                      .docs[index]
                                                                      .data()[
                                                                  "image"]),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0),
                                                        child: Text(
                                                          snapshot.data
                                                                  .docs[index]
                                                                  .data()[
                                                              "name_marathi"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          onTap: () async {
                                            var docID =
                                                snapshot.data.docs[index].id;
                                            // print(docID);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        specificAarti_view(
                                                            id: docID)));
                                          },
                                        );
                                      },
                                    );
                            }
                          },
                        );
                      }
                      return StreamBuilder<QuerySnapshot>(
                        stream: (aartiName != "" && aartiName != null)
                            ? (aartiName
                                    .toLowerCase()
                                    .startsWith(new RegExp('[a-z]')))
                                ? FirebaseFirestore.instance
                                    .collection("Aartis")
                                    .orderBy("name_english")
                                    .startAt([aartiName]).endAt(
                                        [aartiName + "\uf88f"]).snapshots()
                                : FirebaseFirestore.instance
                                    .collection("Aartis")
                                    .orderBy("name")
                                    .startAt([aartiName]).endAt(
                                        [aartiName + "\uf88f"]).snapshots()
                            : FirebaseFirestore.instance
                                .collection("FavouriteAartis")
                                .doc(userId)
                                .collection("FavouriteAartis")
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                            return Center(
                              child: Text(
                                "Sorry Aarti Not Found",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            );
                          } else {
                            return (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // DocumentSnapshot data =
                                      //     snapshot.data.docs[index];
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child: Container(
                                              height: 60.0,
                                              child: Card(
                                                elevation: 10.0,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        child: Image.network(
                                                            snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                "image"]),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      child: Text(
                                                        snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            "name_marathi"],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        onTap: () async {
                                          var docID =
                                              snapshot.data.docs[index].id;
                                          // print(docID);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      specificAarti_view(
                                                          id: docID)));
                                        },
                                      );
                                    },
                                  );
                          }
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }))),
    );
  }
}
