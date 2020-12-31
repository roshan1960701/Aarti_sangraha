import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:notification_banner/notification_banner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class customNotification extends StatefulWidget {
  @override
  _customNotificationState createState() => _customNotificationState();
}

class _customNotificationState extends State<customNotification> {
  String firebaseAppToken = '';
  bool notificationsAllowed = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int counter = 0;

  @override
  void initState() {
    initializeApp();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      notificationsAllowed = isAllowed;
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().fcmTokenStream.listen((String newFcmToken) {
      print("New FCM token: " + newFcmToken);
    });

    AwesomeNotifications()
        .createdStream
        .listen((ReceivedNotification notification) {
      print("Notification created: " +
          (notification.title ??
              notification.body ??
              notification.id.toString()));
    });

    AwesomeNotifications()
        .displayedStream
        .listen((ReceivedNotification notification) {
      print("Notification displayed: " +
          (notification.title ??
              notification.body ??
              notification.id.toString()));
    });

    AwesomeNotifications()
        .dismissedStream
        .listen((ReceivedAction dismissedAction) {
      print("Notification dismissed: " +
          (dismissedAction.title ??
              dismissedAction.body ??
              dismissedAction.id.toString()));
    });

    AwesomeNotifications().actionStream.listen((ReceivedAction action) {
      print("Action received!");

      // Avoid to open the notification details page twice
    });

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    super.initState();
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        color: Color(0xFFfc0307));
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Tutorial', 'Local Notification', platform,
        payload: 'AndroidCoding.in');
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(url);
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _showNotificationMediaStyle() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://i.pinimg.com/originals/b8/46/0c/b8460c550fb4a5c25dc947456ffce683.jpg',
        'largeIcon');
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: const MediaStyleInformation(),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> _showBigPictureNotificationHiddenLargeIcon() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: 'overridden <b>big</b> content title',
            htmlFormatContentTitle: true,
            summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('big text channel id',
            'big text channel name', 'big text channel description',
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  void initializeApp() async {
    AwesomeNotifications().initialize(
        null, // this makes you use your default icon, if you haven't one
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Colors.blueAccent,
              ledColor: Colors.white)
        ]);
  }

  Future<void> initializeFirebaseService() async {
    String firebaseAppToken;
    bool isFirebaseAvailable;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      isFirebaseAvailable = await AwesomeNotifications().isFirebaseAvailable;

      if (isFirebaseAvailable) {
        try {
          firebaseAppToken = await AwesomeNotifications().firebaseAppToken;
          print('Firebase token: $firebaseAppToken');
        } on Exception {
          firebaseAppToken = 'failed';
          print('Firebase failed to get token');
        }
      } else {
        firebaseAppToken = 'unavailable';
        print('Firebase is not available on this project');
      }
    } on Exception {
      isFirebaseAvailable = false;
      firebaseAppToken = 'Firebase is not available on this project';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      firebaseAppToken = firebaseAppToken;
      return;
    }

    setState(() {
      firebaseAppToken = firebaseAppToken;
    });
  }

  Future<void> requestUserPermission() async {
    showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              buttonOkText:
                  Text('Allow', style: TextStyle(color: Colors.white)),
              buttonCancelText:
                  Text('Later', style: TextStyle(color: Colors.white)),
              buttonCancelColor: Colors.grey,
              buttonOkColor: Colors.deepPurple,
              buttonRadius: 0.0,
              image: Image.network(
                  "https://miro.medium.com/max/800/1*zzTEyTwyy7jXibtqVWg84Q.gif",
                  fit: BoxFit.fitHeight),
              title: Text('Get Notified!',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
              description: Text(
                'Allow Awesome Notifications to send to you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              onCancelButtonPressed: () async {
                Navigator.of(context).pop();
                notificationsAllowed =
                    await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  notificationsAllowed = notificationsAllowed;
                });
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                await AwesomeNotifications()
                    .requestPermissionToSendNotifications();
                notificationsAllowed =
                    await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  notificationsAllowed = notificationsAllowed;
                });
              },
            ));
  }

  void sendNotification() async {
    if (!notificationsAllowed) {
      await requestUserPermission();
    }

    if (!notificationsAllowed) {
      return;
    }

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 100,
            channelKey: "basic_channel",
            title: "Huston! The eagle has landed!",
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            notificationLayout: NotificationLayout.BigPicture,
            largeIcon: "https://avidabloga.files.wordpress.com/2012/08/emmemc3b3riadeneilarmstrong3.jpg",
            bigPicture: "https://www.dw.com/image/49519617_303.jpg",
            // backgroundColor: Colors.purpleAccent,
            // color: Colors.greenAccent,
            showWhen: true,
            autoCancel: true,
            payload: {"secret": "Awesome Notifications Rocks!"}));
  }

  void sendLocalImageNotification() async {
    if (!notificationsAllowed) {
      await requestUserPermission();
    }

    if (!notificationsAllowed) {
      return;
    }

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 101,
            channelKey: "basic_channel",
            title: "Best Places To Go On A Hot Air Balloon!",
            notificationLayout: NotificationLayout.MediaPlayer,
            body: "Check out the best places to go on a hot Air Balloon!",
            bigPicture: "https://wallpapercave.com/wp/o4dMEtw.jpg",
            showWhen: true,
            //backgroundColor: Colors.purpleAccent,
            // color: Colors.lightBlue,
            autoCancel: true,
            payload: {"secret": "Awesome Notifications Rocks!"}));
  }

  void cancelAllNotifications() {
    AwesomeNotifications().cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          shrinkWrap: true,
          children: <Widget>[
            RaisedButton(
                onPressed: () => requestUserPermission(),
                child: Text('Request User Permission')),
            SizedBox(height: 20),
            RaisedButton(
                onPressed: () => sendNotification(),
                child: Text('Send a local notification')),
            RaisedButton(
                onPressed: () => sendLocalImageNotification(),
                child: Text('Send a local notification with local files')),
            SizedBox(height: 20),
            RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () => cancelAllNotifications(),
                child: Text('Cancel all notifications')),
            RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: () {
                  NotificationBanner(context)
                    ..setBody(Container(
                      color: Colors.green,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                      ),
                    ))
                    ..show(Appearance.top);
                },
                child: Text('Notification_banner 1')),
            RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: () {
                  NotificationBanner(context)
                    ..setMessage('Changed border radius')
                    ..setBorderRadius(16.0)
                    ..show(Appearance.top);
                },
                child: Text('Notification_banner 2')),
            RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: () {
                  NotificationBanner(context)
                    ..setMessage('Changed text style')
                    ..setTextStyle(TextStyle(
                        color: Colors.purple,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic))
                    ..show(Appearance.top);
                },
                child: Text('Notification_banner 3')),
            RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: () {
                  NotificationBanner(context)
                    ..setMessage('Different color')
                    ..setBgColor(Colors.brown)
                    ..show(Appearance.top);
                },
                child: Text('Notification_banner 4')),
            RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: () {
                  // showNotification();
                  // _showNotificationMediaStyle();
                  _showBigPictureNotificationHiddenLargeIcon();
                },
                child: Text('Local Notification')),
          ]),
    ));
  }
}
