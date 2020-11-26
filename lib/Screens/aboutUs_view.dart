import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class aboutUs_view extends StatefulWidget {
  aboutUs_view({Key key}) : super(key: key);

  @override
  _aboutUs_viewState createState() => _aboutUs_viewState();
}

class _aboutUs_viewState extends State<aboutUs_view> {
  final firestoreInstance = Firestore.instance;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController feedbackController = new TextEditingController();
  String insertedDate = DateTime.now().toString();
  ProgressDialog pr;

  Future<void> _sendFeedback() async {
    firestoreInstance.collection("Feedback").add({
      "Name": nameController.text,
      "Feedback": feedbackController.text,
      "Inserted_date": insertedDate
    }).then((value) {
      pr.show();
      Future.delayed(Duration(seconds: 4)).then((value) {
        pr.hide().whenComplete(() {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => home_view()));
        });
      });
      nameController.clear();
      feedbackController.clear();
    });
  }

  void sendEmail() async => launch("mailto:roshanw1998@gmail.com");

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
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
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 10.0,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(""),
            Text("Flutter Developer"),
            InkWell(
              child: Text(
                "roshanw1998@gmail.com",
                style: TextStyle(fontSize: 20.0, color: Colors.blue),
              ),
              onTap: () async {
                sendEmail();
                // Share.share(
                //   'Hello',
                //   subject: "For Suggestions",
                // );
              },
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter your Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        controller: feedbackController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your Feedback";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: "Feedback"),
                        maxLines: 5,
                      ),
                    ),
                    MaterialButton(
                      minWidth: 120.0,
                      height: 40.0,
                      elevation: 10.0,
                      color: Colors.blue,
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          _sendFeedback();
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
