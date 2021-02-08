import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:aarti_sangraha/remoteConfigService.dart';
import 'package:aarti_sangraha/utilities.dart';
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
  var aartiName;
  utilities util = new utilities();

  Icon cusSearchIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget cusAppBar = Text("");
  remoteConfigService _remoteConfigService;
  bool isLoading;

  initializeRemoteConfig() async{
    _remoteConfigService =  await remoteConfigService.getInstance();
    await _remoteConfigService.initialize();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      util.checkConnectivity(context);
    });
    initializeRemoteConfig();
    super.initState();
  }

  Future<QuerySnapshot> unSearchedAarti() async {
    FirebaseFirestore.instance
        .collection("Aartis")
        .where("category", arrayContains: value)
        .snapshots();
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
                              aartiName = val.toLowerCase();
                            });
                          },
                        );
                      } else {
                        this.cusSearchIcon = Icon(Icons.search);
                        this.cusAppBar = Text("");
                        aartiName = null;
                      }
                    });
                  }),
            ],
            title: cusAppBar,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: (aartiName != "" && aartiName != null)
                ? (aartiName.toLowerCase().startsWith(new RegExp('[a-z]')))
                    ? FirebaseFirestore.instance
                        .collection('Aartis')
                        .orderBy("name_english")
                        .startAt([aartiName]).endAt(
                            [aartiName + "\uf88f"]).snapshots()
                    : FirebaseFirestore.instance
                        .collection('Aartis')
                        .orderBy("name")
                        .startAt([aartiName]).endAt(
                            [aartiName + "\uf88f"]).snapshots()
                : FirebaseFirestore.instance
                    .collection("Aartis")
                    .where("category", arrayContains: value)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("No records found"),
                );
              }
              if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text(
                    "Sorry Aarti Not Found",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                );
              } else {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10.0, right: 10.0),
                              child: Container(
                                  height: 60.0,
                                  child: Card(
                                    elevation: 10.0,
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              child: Image.network(
                                                snapshot.data.docs[index]
                                                    .data()["image"],
                                                width: 45.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            snapshot.data.docs[index]
                                                .data()["name_marathi"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              var docID = snapshot.data.docs[index].id;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          specificAarti_view(id: docID)));
                            },
                          );
                        },
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}
