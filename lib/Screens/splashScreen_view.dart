import 'dart:async';
import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class splashScreen_view extends StatefulWidget {
  final String videoPath;
  splashScreen_view({Key key, this.videoPath}) : super(key: key);

  @override
  _splashScreen_viewState createState() => _splashScreen_viewState(videoPath:videoPath);
}

class _splashScreen_viewState extends State<splashScreen_view> {
  String videoPath;
  _splashScreen_viewState({this.videoPath});

  VideoPlayerController controller;
  bool startedPlaying = false;

  File file;
  var video;
  File fileImage;

  String imageData;
  String videoData;
  String videoData1 = " ";
  bool dataLoaded = false;
  bool videoDataLoaded = false;

  bool checkData = false;

  @override
  void initState() {
    check();
    /*controller = VideoPlayerController.asset("asset/video/HeyCloudy.mp4");
    started();
    controller.addListener(() {
      if (startedPlaying && !controller.value.isPlaying) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => home_view()));
      }
    });*/
    super.initState();
  }
  check() async {
    print("Shared Preference: $videoPath");
    setState(() {
      checkData = true;
    });

    if (videoPath == null || videoPath.length == null) {
      controller = VideoPlayerController.asset("asset/video/HeyCloudy.mp4");
    } else {
      controller = VideoPlayerController.file(File(videoPath));
      //started();
    }

    controller.initialize();
    controller.play();
    startedPlaying = true;
    controller.addListener(() {
      if (startedPlaying && !controller.value.isPlaying) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => home_view()));
      }
    });
  }

  Future<bool> started() async {
    await controller.initialize();
    await controller.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // checkFirstSeen();
    return SafeArea(
        child: Scaffold(
            body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF35c1f0), Color(0xFFbce7f5)])
          /*image: DecorationImage(
          image: new ExactAssetImage("asset/logo/launch.jpg"),
        ),*/
          ),
      child:  checkData
          ? VideoPlayer(controller)
          : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF35c1f0), Color(0xFFbce7f5)])),
      ),
    )

            /*Stack(
        children: [
          Image.asset(
            "asset/logo/launch.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                VideoPlayer(controller),
              ],
            ),
          )
        ],
      ),*/
            ));
  }
}
