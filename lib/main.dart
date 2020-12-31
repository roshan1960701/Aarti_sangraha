import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/Screens/onboarding_view.dart';
import 'package:aarti_sangraha/Screens/splashScreen_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Widget defaultWidget;

void main() async {
  splashScreen_view screen_view = new splashScreen_view();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');

  defaultWidget = userId == null ? onboarding_view() : home_view();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aarti Sangraha',
      home: /*splashScreen_view()*/ defaultWidget,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
