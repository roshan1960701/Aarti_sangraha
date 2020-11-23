import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:share/share.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class specificAarti_view extends StatefulWidget {
  var id;
  specificAarti_view({Key key, this.id}) : super(key: key);

  @override
  _specificAarti_viewState createState() => _specificAarti_viewState(id);
}

class _specificAarti_viewState extends State<specificAarti_view> {
  var id;

  bool isPlaying;

  _specificAarti_viewState(this.id);
  final firestoreInstance = FirebaseFirestore.instance;
  var mp3Time;
  String newMp3Time = "00:00";
  Duration _duration = new Duration();
  Duration _position = new Duration();
  var currentTime = "00:00";
  var _newTime;
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localFilePath;

  String aarti = " ", image, mp3, name_marathi = " ", name_english;

  var checkFavourite;
  bool isFavourite = false;
  Icon favouriteIcon = Icon(
    Icons.play_arrow,
    color: Colors.pink[900],
  );
  int iconTaped = 0;

  List<String> aartis = new List<String>();
  List<String> savedAartis = List<String>();

  @override
  void initState() {
    // TODO: implement initState

    checkConnectivity();
    super.initState();
    getSpecificAarti();
    //getSpAart();
    initPlayer();
    checkIsFavourite();
    // get();
  }

  addToFavouriteFirestore() async {
    DocumentReference documentReference =
        firestoreInstance.collection("FavouriteAartis").doc(id);
    documentReference.set({
      'name_marathi': name_marathi,
      'image': image,
      'mp3': mp3,
      'aarti': aarti,
      'name_english': name_english,
    });
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

  checkIsFavourite() async {
    checkFavourite = id;
    // print(checkFavourite);
    firestoreInstance.collection("FavouriteAartis").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        //   print(result.id);

        if (id == result.id) {
          setState(() {
            isFavourite = true;
            // print(isFavourite);
          });
        }
        //print(result.data());
      });
    });
  }

  removeFromFavouriteFirestore() async {
    await firestoreInstance.collection("FavouriteAartis").doc(id).delete();
  }

  addToFavouriteAarti() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('name_marathi', name_marathi);
    sharedPreferences.setString('image', image);
  }

  removeFavouriteAarti() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('name_marathi');
    sharedPreferences.remove('image');
  }

  void initPlayer() async {
    iconTaped = 1;
    isPlaying = true;
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
          // print(
          //     '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}');
          // mp3Time = d.toString().split('.')[0].padRight(5, '0');
          mp3Time =
              '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
          newMp3Time = mp3Time.toString();
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
          //_currentTime = p;
        });
    advancedPlayer.onAudioPositionChanged.listen((event) {
      print("current position: $event");
      setState(() {
        _newTime =
            '${event.inMinutes.remainder(60).toString().padLeft(2, '0')}:${event.inSeconds.remainder(60).toString().padLeft(2, '0')}';
        currentTime = _newTime.toString();
      });
    });
  }

  Widget _tab(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ],
    );
  }

  // Widget _btn(String icon, VoidCallback onPressed) {
  //   return ButtonTheme(
  //     minWidth: 48.0,
  //     child: Container(
  //       width: 150,
  //       height: 45,
  //       child: IconButton(
  //           icon: icon,
  //           child: Text(txt),
  //           color: Colors.pink[900],
  //           textColor: Colors.white,
  //           onPressed: onPressed),
  //     ),
  //   );
  // }

  Widget LocalAudio() {
    return _tab([
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                //icon: favouriteIcon,

                icon: isPlaying
                    ? Icon(
                        Icons.play_arrow,
                        size: 28.0,
                        color: Colors.pink[900],
                      )
                    : Icon(
                        Icons.pause,
                        size: 25.0,
                        color: Colors.pink[900],
                      ),
                onPressed: () async {
                  // if (iconTaped == 1) {
                  //   advancedPlayer.play('$mp3');
                  //   favouriteIcon = Icon(
                  //     Icons.pause,
                  //     color: Colors.pink[900],
                  //   );
                  //   iconTaped = 0;
                  // } else {
                  //   advancedPlayer.pause();
                  //   favouriteIcon = Icon(
                  //     Icons.play_arrow,
                  //     color: Colors.pink[900],
                  //   );
                  //   iconTaped = 0;
                  // }
                  // setState(() {});

                  if (isPlaying) {
                    checkConnectivity();
                    await advancedPlayer.play('$mp3');
                    isPlaying = false;
                  } else if (!isPlaying) {
                    await advancedPlayer.pause();
                    isPlaying = true;
                  }
                  setState(() {});
                },

                // IconButton(
                //     onPressed: () => advancedPlayer.pause(),
                //     icon: Icon(
                //       Icons.pause,
                //       size: 25.0,
                //       color: Colors.pink[900],
                //     )),
                // IconButton(
                //     onPressed: () {
                //       advancedPlayer.stop();
                //       //_position = Duration(minutes: 0, seconds: 0);
                //     },
                //     icon: Icon(
                //       Icons.stop,
                //       size: 25.0,
                //       color: Colors.pink[900],
                //     ))
              )
            ],
          ),
          slider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$currentTime"),
              Text("$newMp3Time"),
            ],
          )
        ],
      ),
    ]);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    // mp3Time = newDuration;
    // print("TotalTime :" + mp3Time);
    advancedPlayer.seek(newDuration);
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.black,
        inactiveColor: Colors.pink,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          value = value;
          seekToSecond(value.toInt());
          setState(() {
            // value = value;
            // seekToSecond(value.toInt());
          });
        });
  }

  Future<QuerySnapshot> getImages() async {
    // DocumentReference docRef = firestoreInstance.collection("Aartis").get();
    firestoreInstance.collection("Aartis").doc(id).get().then((value) => {});
    // var result = firestoreInstance.collection("Aartis").doc(id).get();
    // if (result != null) {
    //   print(result);
    // }
  }

  Future<QuerySnapshot> getSpecificAarti() async {
    if (QuerySnapshot != null) {
      firestoreInstance.collection("Aartis").doc(id).get().then((value) {
        if (value.id.length > 0) {
          setState(() {
            name_marathi = value["name_marathi"];
            aarti = value["aarti"];
            image = value["image"];
            mp3 = value["mp3"];
            name_english = value["name_english"];
          });

          // print(name_marathi);
          // print(aarti);
          // print(image);
          // print(mp3);
          // var data= value.id;
          // print(data);
        }
      });
    }
    // var result = firestoreInstance.collection("Aartis").doc(id).get();
    // if (result != null) {
    //   print(result);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        advancedPlayer.stop();
        Navigator.pop(context);
      },
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
                        advancedPlayer.stop();
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          Share.share('To listen this Aarti ' +
                              '$name_marathi' +
                              ' Download the Mp3 File\n' +
                              '$mp3');
                        },
                        child: IconButton(
                          tooltip: "Click to share",
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      IconButton(
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: isFavourite ? Colors.red : null,
                        ),
                        onPressed: () async {
                          if (isFavourite) {
                            // savedWords.remove(word);
                            await removeFromFavouriteFirestore();
                            isFavourite = false;
                          } else {
                            await addToFavouriteFirestore();
                            isFavourite = true;
                          }
                          setState(() {});
                          // setState(() {
                          //   if (iconTaped == 0) {
                          //     addToFavouriteFirestore();
                          //     favouriteIcon = Icon(
                          //       Icons.favorite,
                          //       color: Colors.red,
                          //     );
                          //     iconTaped = 1;
                          //   } else {
                          //     favouriteIcon = Icon(Icons.favorite_border);
                          //     iconTaped = 0;
                          //   }
                          // }
                        },
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: LocalAudio(),
              )
            ],
          ),
        )),
      ),
    );
  }
}
