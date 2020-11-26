import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/Screens/onboarding_view.dart';
import 'package:aarti_sangraha/Screens/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget defaultWidget;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');

  defaultWidget = userId == null ? onboarding_view() : home_view();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aarti Sangraha',
      home: defaultWidget,
    );
  }
}

// class homePage extends StatefulWidget {
//   @override
//   _homePageState createState() => _homePageState();
// }
//
// class _homePageState extends State<homePage> {
//   Future checkFirstSeen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool _seen = (prefs.getBool('seen') ?? false);
//
//     if (_seen) {
//       Navigator.of(context).pushReplacement(
//           new MaterialPageRoute(builder: (context) => new splashScreen_view()));
//     } else {
//       await prefs.setBool('seen', true);
//       Navigator.of(context).pushReplacement(
//           new MaterialPageRoute(builder: (context) => new onboarding_view()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     checkFirstSeen();
//     return Scaffold();
//   }
// }
