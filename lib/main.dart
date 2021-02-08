import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/Screens/onboarding_view.dart';
import 'package:aarti_sangraha/Screens/remoteConfig.dart';
import 'package:aarti_sangraha/Screens/splashScreen_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Widget defaultWidget;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String videoPath = sharedPreferences.getString('videoLink');
  defaultWidget = userId == null ? onboarding_view() : home_view();

  runApp(myApp(videoPath:videoPath));
}

class myApp extends StatelessWidget {
  final String videoPath;
  myApp({Key key, @required this.videoPath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aarti Sangraha',
      home: splashScreen_view(videoPath:videoPath) /*defaultWidget*//*remoteConfig()*/,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
