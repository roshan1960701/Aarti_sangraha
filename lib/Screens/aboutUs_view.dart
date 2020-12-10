import 'dart:io';
import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/Screens/listWheel.dart';
import 'package:aarti_sangraha/Widgets/customRatings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_app/rate_my_app.dart';

class aboutUs_view extends StatefulWidget {
  aboutUs_view({Key key}) : super(key: key);

  @override
  _aboutUs_viewState createState() => _aboutUs_viewState();
}

class _aboutUs_viewState extends State<aboutUs_view> {
  customRatings custRatings = new customRatings();
  final fireStoreInstance = Firestore.instance;
  bool ignorePointer = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController feedbackController = new TextEditingController();
  String insertedDate = DateTime.now().toString();
  ProgressDialog progressDialog;

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'listen.to.heycloudy',
    appStoreIdentifier: '1491556149',
  );

  @override
  void initState() {
    rateMyApp.init().then((_) => {
          /*rateMyApp.showRateDialog(
            context,
            title: "Rating Dialog",
            message: "Please Give us Ratings!!!",
            laterButton: "MAYBE LATER",
            rateButton: "RATE",
            listener: (button) {
              // The button click listener (useful if you want to cancel the click event).
              switch (button) {
                case RateMyAppDialogButton.rate:
                  print('Clicked on "Rate".');
                  break;
                case RateMyAppDialogButton.later:
                  print('Clicked on "Later".');
                  break;
                case RateMyAppDialogButton.no:
                  print('Clicked on "No".');
                  break;
              }

              return true; // Return false if you want to cancel the click event.
            },
            ignoreNativeDialog: Platform
                .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
            dialogStyle: DialogStyle(), // Custom dialog styles.
            onDismissed: () => rateMyApp
                .callEvent(RateMyAppEventType.laterButtonPressed), // Calle
          ),*/
          rateMyApp.showStarRateDialog(
            context,
            title: 'Rate this app', // The dialog title.
            message:
                'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
            // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
            actionsBuilder: (context, stars) {
              // Triggered when the user updates the star rating.
              return [
                /*TextFormField(
                  decoration: InputDecoration(hintText: "Review"),
                ),*/
                // Return a list of actions (that will be shown at the bottom of the dialog).
                FlatButton(
                  child: Text('Rate'),
                  onPressed: () async {
                    print('Thanks for the ' +
                        (stars == null ? '0' : stars.round().toString()) +
                        ' star(s) !');
                    // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                    // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                    await rateMyApp
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            ignoreNativeDialog: Platform
                .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
            dialogStyle: DialogStyle(
              // Custom dialog styles.
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions:
                StarRatingOptions(), // Custom star bar rating options.
            onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          ),
        });

    initApp();
    super.initState();
  }

  initApp() async {
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message:
              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
          rateButton: 'RATE', // The dialog "rate" button text.
          noButton: 'NO THANKS', // The dialog "no" button text.
          laterButton: 'MAYBE LATER', // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreNativeDialog: Platform
              .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: DialogStyle(), // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );

        // Or if you prefer to show a star rating bar :

        rateMyApp.showStarRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message:
              'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
          // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          actionsBuilder: (context, stars) {
            // Triggered when the user updates the star rating.
            return [
              // Return a list of actions (that will be shown at the bottom of the dialog).
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  print('Thanks for the ' +
                      (stars == null ? '0' : stars.round().toString()) +
                      ' star(s) !');
                  // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                  // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                  await rateMyApp
                      .callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                },
              ),
            ];
          },
          ignoreNativeDialog: Platform
              .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: DialogStyle(
            // Custom dialog styles.
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20),
          ),
          starRatingOptions:
              StarRatingOptions(), // Custom star bar rating options.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        );
      }
    });
  }

  Future<void> _sendFeedback() async {
    progressDialog.show();
    Future.delayed(Duration(seconds: 2)).then((value) {
      progressDialog.hide().whenComplete(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => home_view()));
        fireStoreInstance.collection("Feedback").add({
          "Name": nameController.text,
          "Feedback": feedbackController.text,
          "Inserted_date": insertedDate
        });
      });
    });
  }

  Widget formText(field) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            field,
            style: GoogleFonts.poppins(
                fontSize: 14.0, fontStyle: FontStyle.normal),
          )),
    );
  }

  void sendEmail() async => launch("mailto:roshanw1998@gmail.com");

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    progressDialog.style(
//      message: 'Downloading file...',
      message: 'Please Wait!!!',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            elevation: 10.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF06701), Color(0xFFFF8804)])),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => home_view()));
              },
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Flutter Developer"),
                InkWell(
                  child: Text(
                    "roshanw1998@gmail.com",
                    style: TextStyle(fontSize: 20.0, color: Color(0xFFFF8C00)),
                  ),
                  onTap: () async {
                    sendEmail();
                    // Share.share(
                    //   'Hello',
                    //   subject: "For Suggestions",
                    // );
                  },
                ),
                IgnorePointer(
                  ignoring: ignorePointer,
                  child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 40.0,
                          right: 40.0,
                        ),
                        child: Column(
                          children: [
                            formText("Name"),
                            TextFormField(
                              controller: nameController,
                              autovalidate: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter your Name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide:
                                      BorderSide(color: Color(0x73000000)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFF8C00)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide:
                                      BorderSide(color: Color(0x73000000)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFF8C00)),
                                ),
                              ),
                            ),
                            formText("Feedback"),
                            TextFormField(
                              controller: feedbackController,
                              autovalidate: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter your Feedback";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefix: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide:
                                      BorderSide(color: Color(0x73000000)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFF8C00)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide:
                                      BorderSide(color: Color(0x73000000)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFF8C00)),
                                ),
                              ),
                              maxLines: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: MaterialButton(
                                elevation: 10.0,
                                height: 40.0,
                                splashColor: Colors.white,
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      ignorePointer = true;
                                    });
                                    _sendFeedback();
                                  }
                                },
                                child: Container(
                                  height: 40.0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 105.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFF06701),
                                        Color(0xFFFF8804)
                                      ])),
                                  child: Text(
                                    "Submit",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 20.0, right: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(100.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFF06701),
                                    Color(0xFFFF8804)
                                  ]),
                                ),
                                child: FlatButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => customRatings());
                                    },
                                    child: Text(
                                      "Ratings",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontStyle: FontStyle.normal),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 20.0, right: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(100.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFF06701),
                                    Color(0xFFFF8804)
                                  ]),
                                ),
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  listWheel()));
                                    },
                                    child: Text(
                                      "ListWheel",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontStyle: FontStyle.normal),
                                    )),
                              ),
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
