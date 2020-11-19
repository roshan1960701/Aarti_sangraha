import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:share/share.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

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
  var mp3Time;
  String newMp3Time = "00:00";
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localFilePath;

  String aarti, image, mp3, name_marathi;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getSpecificAarti();
    initPlayer();
    // get();
  }

  void initPlayer() async {
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
                  onPressed: () => advancedPlayer.play('$mp3'),
                  icon: Icon(
                    Icons.play_arrow,
                    size: 28.0,
                    color: Colors.pink[900],
                  )),
              IconButton(
                  onPressed: () => advancedPlayer.pause(),
                  icon: Icon(
                    Icons.pause,
                    size: 25.0,
                    color: Colors.pink[900],
                  )),
              IconButton(
                  onPressed: () => advancedPlayer.stop(),
                  icon: Icon(
                    Icons.stop,
                    size: 25.0,
                    color: Colors.pink[900],
                  ))
            ],
          ),
          slider(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("$newMp3Time"),
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
          setState(() {
            seekToSecond(value.toInt());
            value = value;
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
    firestoreInstance.collection("Aartis").doc(id).get().then((value) {
      if (value.id.length > 0) {
        setState(() {
          name_marathi = value["name_marathi"];
          aarti = value["aarti"];
          image = value["image"];
          mp3 = value["mp3"];
        });

        // print(name_marathi);
        // print(aarti);
        // print(image);
        // print(mp3);
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
                      tooltip: "Click to share",
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
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
