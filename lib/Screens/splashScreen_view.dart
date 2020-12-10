import 'dart:async';
import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class splashScreen_view extends StatefulWidget {
  splashScreen_view({Key key}) : super(key: key);

  @override
  _splashScreen_viewState createState() => _splashScreen_viewState();
}

class _splashScreen_viewState extends State<splashScreen_view> {
  VideoPlayerController controller;
  bool startedPlaying = false;

  @override
  void initState() {
    controller = VideoPlayerController.asset("asset/video/HeyCloudy.mp4");
    started();
    controller.addListener(() {
      if (startedPlaying && !controller.value.isPlaying) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => home_view()));
      }
    });
    super.initState();
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
      child: VideoPlayer(controller),
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
