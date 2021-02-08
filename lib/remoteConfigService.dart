import 'package:aarti_sangraha/videoDownload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class remoteConfigService{
   String splashScreenUrl,splashScreenDate;

  final RemoteConfig _remoteConfig;
  final videoDownload _videoDownload = new videoDownload();
  remoteConfigService({RemoteConfig remoteConfig}): _remoteConfig = remoteConfig;

  final defaults = <String,dynamic>{
  'SplashScreenUrl':'',
  'SplashScreenDate':''
  };

  static remoteConfigService _instance;
  static Future<remoteConfigService> getInstance() async{
    if(_instance == null){
      _instance = remoteConfigService(
      remoteConfig: await RemoteConfig.instance,
      );
  }
    return _instance;
  }

  String get getRemoteUrl => _remoteConfig.getString('SplashScreenUrl');
  String get getRemoteDate => _remoteConfig.getString('SplashScreenDate');

  Future initialize() async{
    try{
       await _remoteConfig.setDefaults(defaults);
       await _fetchAndActivate();
   } on FetchThrottledException catch(e){
      print("Remote config fetch throttle: $e");
    } catch(e){
      print("Unable to fetch remote config. Default value will be used");
    }
   }

   Future _fetchAndActivate() async{
    await _remoteConfig.fetch(expiration: Duration(milliseconds: 100));
    await _remoteConfig.activateFetched();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var splashUrl = sharedPreferences.getString('splashUrl') ?? ' ';
    var splashDate = sharedPreferences.getString('splashDate') ?? ' ';

    print("Remote URL $getRemoteUrl");
    print("Remote Date $getRemoteDate");
    print("Splash URL $splashUrl");

    if(splashUrl.isEmpty){
      sharedPreferences.setString('splashUrl', getRemoteUrl);
      sharedPreferences.setString('splashDate', getRemoteDate);
      print("splashUrl is empty");
    }
    else{
        if(getRemoteDate.compareTo(splashDate)>=0){
          if(getRemoteDate == splashDate){
            //Do Nothing
            print("Dates are same");
          }
          else{
            print("Remote Url: $getRemoteUrl");
            print("Remote Date: $getRemoteDate");
            _videoDownload.downloadVideoOnline(getRemoteUrl, getRemoteDate);
            sharedPreferences.setString('splashDate', getRemoteDate);
          }
        }
    }





   }


}