import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class utilities {
  checkConnectivity(BuildContext context) async {
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

  statusBarVisibility() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  double calculateWX(double x, BuildContext context) {
    double baseWidth = 360;

    double deviceWidth = MediaQuery.of(context).size.width;

    return x = ((x * deviceWidth) / baseWidth);
  }

  double calculateHY(double y, BuildContext context) {
    double baseHeight = 640;

    double deviceHeight = MediaQuery.of(context).size.height;

    return y = ((y * deviceHeight) / baseHeight);
  }
}
