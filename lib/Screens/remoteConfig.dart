import 'package:aarti_sangraha/remoteConfigService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class remoteConfig extends StatefulWidget {
  @override
  _remoteConfigState createState() => _remoteConfigState();
}

class _remoteConfigState extends State<remoteConfig> {
  String splashScreenUrl,splashScreenDate;
  int id=0;
  remoteConfigService _remoteConfigService = new remoteConfigService();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      // remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchIntervalMillis: 1));

      final defaults = <String, dynamic>{
        'SplashScreenUrl':'',
          'SplashScreenDate':''
      };
      /*remoteConfig.setDefaults(defaults);

      setState(() {
        splashScreenUrl = defaults['SplashScreenUrl'];
        splashScreenDate = defaults['SplashScreenDate'];
      });*/

      await remoteConfig.fetch(expiration: const Duration(milliseconds: 100),);
      await remoteConfig.activateFetched();

      print("Server Url: "+remoteConfig.getString('SplashScreenUrl'));
      print("Server Date: "+remoteConfig.getString('SplashScreenDate'));

      // setState(() {
      //   splashScreenUrl = remoteConfig.getString('SplashScreenUrl');
      //   splashScreenDate = remoteConfig.getString('SplashScreenDate');
      // });



    });


  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SplashScreenUrl: $splashScreenUrl"),
            Text("Date: $splashScreenDate"),
            Text("$id"),
            RaisedButton(onPressed: (){
              setState(() {
                id++;
              });
            },
            child: Text("Refresh"),
            )
          ],
        ),
      )

    );
  }
}


