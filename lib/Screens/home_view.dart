import 'package:aarti_sangraha/Screens/aartList_view.dart';
import 'package:aarti_sangraha/drawer.dart';
import 'package:aarti_sangraha/remoteConfigService.dart';
import 'package:aarti_sangraha/utilities.dart';
import 'package:aarti_sangraha/videoDownload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:translator/translator.dart';
import 'dart:io';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class home_view extends StatefulWidget {
  home_view({Key key}) : super(key: key);

  @override
  _home_viewState createState() => _home_viewState();
}

class _home_viewState extends State<home_view> {
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3,
    minLaunches: 7,
    remindDays: 2,
    remindLaunches: 5,
    // appStoreIdentifier: '',
    // googlePlayIdentifier: '',
  );

  videoDownload _videoDownload = new videoDownload();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  utilities util = new utilities();
  final fireStoreInstance = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
 remoteConfigService _remoteConfigService;
  String token = " ";
  final translator = GoogleTranslator();
  String splashScreenUrl,splashScreenDate;
  bool isLoading;


  initializeRemoteConfig() async{
     _remoteConfigService =  await remoteConfigService.getInstance();
     await _remoteConfigService.initialize();
/*     setState(() {
       isLoading = false;
     });*/
  }
  @override
  void initState() {
    // TODO: implement initState
    initializeRemoteConfig();
    getToken();

    //remoteService();

    FirebaseAnalytics().setCurrentScreen(screenName: "HomeScreen");
    FirebaseAnalytics().setUserProperty(
        name: "Aarti_home", value: "Aarti_sangraha");
    /*AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    awesomeNotifications.initialize('resource://drawable/res_app_icon',
        [NotificationChannel(defaultColor: Colors.red)]);
    awesomeNotifications.createNotification(
        content: NotificationContent(
      title: 'Emojis are awesome too!',
      body: 'Testing',
      bigPicture: 'https://tecnoblog.net/wp-content/uploads/2019/09/emoji.jpg',
      backgroundColor: Colors.purpleAccent,
    ));*/

    Future.delayed(Duration.zero, () {
      util.checkConnectivity(context);
    });

    util.statusBarVisibility();

    /*_rateMyApp.init().then((_) {
      // TODO: Comment out this if statement to test rating dialog (Remember to uncomment)
      // if (_rateMyApp.shouldOpenDialog) {
      _rateMyApp.showStarRateDialog(
        context,
        title: 'Ratings!!!',
        message: 'Please leave a rating!',
        actionsBuilder: (context, stars) {
          return [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                if (stars != null) {
                  // _rateMyApp.doNotOpenAgain = true;
                  _rateMyApp.save().then((v) => Navigator.pop(context));

                  if (stars <= 3) {
                    print('Navigate to Contact Us Screen');
                  } else if (stars <= 5) {
                    print('Leave a Review Dialog');
                    // showDialog(...);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ];
        },
        dialogStyle: DialogStyle(
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          messagePadding: EdgeInsets.only(bottom: 20.0),
        ),
        starRatingOptions: StarRatingOptions(),
      );
      // }
    });*/
    super.initState();
  }

 /* remoteService() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      // remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   debugMode: true));

      final defaults = <String, dynamic>{
        'SplashScreenUrl':'',
        'SplashScreenDate':''
      };
      remoteConfig.setDefaults(defaults);
      setState(() {
        splashScreenUrl = defaults['SplashScreenUrl'];
        splashScreenDate = defaults['SplashScreenDate'];
      });

      await remoteConfig.fetch(expiration: const Duration(seconds:0),);
      await remoteConfig.activateFetched().then((value){
        print("Value: $value");
      });

      setState(() {
        splashScreenUrl = remoteConfig.getString('SplashScreenUrl');
        splashScreenDate = remoteConfig.getString('SplashScreenDate');
        _videoDownload.downloadVideoOnline(splashScreenUrl,splashScreenDate);
      });



    });
  }*/

  getToken() async {
    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    firebaseMessaging.getToken().then((value) {
      token = value.toString();
      print("Token: $token");
    }).catchError((onError) {
      print("Exception: $onError");
    });
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Message: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        _navigateToItemDetail(message);
        print("Resume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        _navigateToItemDetail(message);
        print("Launch: $message");
      },
    );
    firebaseMessaging.subscribeToTopic("AartiSangraha");
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    // Clear away dialogs
    var notificationData = message['data'];
    var id = notificationData['id'];
    print(id);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => specificAarti_view(id: id)));
  }

  // getSearchAarti() async {
  //   FirebaseFirestore.instance.collection('Aartis').where().get().then((value) {
  //     value.docs.forEach((element) {
  //       print(element.data());
  //     });
  //   });
  // }

  navigateSpecificAart() async {}

  Widget customAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, util.calculateHY(56, context)),
      child: SafeArea(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  }),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: aartiSearchDelegate(),
                    );
                  }),
            ],
          ),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(20.0)),
              gradient: LinearGradient(
                  colors: [Color(0xFFF06701), Color(0xFFFF8804)])),
        ),
      ),
    );
  }

  Future<QuerySnapshot> getArtiSangraha() async {
    if (QuerySnapshot != null) {
      return fireStoreInstance.collection("AartiSangraha").get();
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Exit"),
                content: Text("Are you want Exit?"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(color: Color(0xFFF06701)),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("Cancel",
                          style: TextStyle(color: Color(0xFFF06701)))),
                ],
              );
            });
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: customAppBar(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                title: Text(
                                    "Please check your Internet Connection"),
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
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
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
      child: Container(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return StreamBuilder(
        stream: (query != "" && query != null)
            ? (query.toLowerCase().startsWith(new RegExp('[a-z]')))
                ? FirebaseFirestore.instance
                    .collection('Aartis')
                    .orderBy("name_english")
                    .startAt([query.toLowerCase()]).endAt(
                        [query.toLowerCase() + "\uf88f"]).snapshots()
                : FirebaseFirestore.instance
                    .collection('Aartis')
                    .orderBy("name")
                    .startAt([query]).endAt([query + "\uf88f"]).snapshots()
            : FirebaseFirestore.instance.collection("Aartis").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Center(
              child: Text(
                "Sorry Aarti Not Found",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
            );
          } else {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Container(
                              height: 60.0,
                              child: Card(
                                child: Row(
                                  children: [
                                    Padding(
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        snapshot.data.docs[index]
                                            .data()["name_marathi"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
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
        });
    throw UnimplementedError();
  }
}
