import 'package:aarti_sangraha/Screens/home_view.dart';
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
  var title, img, aartiName;
  var id;
  Icon cusSearchIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget cusAppBar = Text("");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getFavouriteAartis();
  }

  getFavouriteAartis() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //Return String
    String name_marathi = sharedPreferences.getString('name_marathi');
    String image = sharedPreferences.getString('image');
    print(name_marathi);
    print(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                    setState(() {
                      if (this.cusSearchIcon.icon == Icons.search) {
                        this.cusSearchIcon = Icon(Icons.cancel);
                        this.cusAppBar = TextField(
                          textInputAction: TextInputAction.go,
                          onChanged: (val) {
                            setState(() {
                              aartiName = val;
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
                      }
                    });
                  });
                })
          ],
          title: cusAppBar,
        ),
        body: WillPopScope(
          child: Scaffold(
            body: StreamBuilder<QuerySnapshot>(
              stream: (aartiName != "" && aartiName != null)
                  ? Firestore.instance
                      .collection("FavouriteAartis")
                      .orderBy("name_english")
                      .startAt([aartiName]).endAt(
                          [aartiName + "\uf88f"]).snapshots()
                  : Firestore.instance
                      .collection("FavouriteAartis")
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
                                    leading: Image.network(snapshot
                                        .data.docs[index]
                                        .data()["image"]),
                                    title: Text(
                                      snapshot.data.docs[index]
                                          .data()["name_marathi"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
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
          ),
        ));
  }
}
