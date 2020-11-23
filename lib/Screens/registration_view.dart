import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:aarti_sangraha/Model/databaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class registration_view extends StatefulWidget {
  registration_view({Key key}) : super(key: key);

  @override
  _registration_viewState createState() => _registration_viewState();
}

class _registration_viewState extends State<registration_view> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  final dbhelper = databaseHelper.instance;
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  final TextEditingController fistNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool connectivityCheck;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _googleAuth;

  bool isUserSignedIn = false;

  String name;
  String lastName;
  String email;
  String date;

  ProgressDialog pr;
  DateTime selectedDate = DateTime.now();
  String insertedDate = DateTime.now().toString();
  DateTime newDate = DateTime.now();
  // DateTime fiftyDaysAgo = newDate.subtract(new Duration(days: 50));

  //bool send = false;

  TextStyle btnStyle = new TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20.0);

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.purple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    checkConnectivity();
    super.initState();
    newDate.subtract(Duration());
    initApp();
    //queryall();
    // _signInWithEmailAndLink();
    // _emailSignIn();
    // sendSignInLinkToEmail("roshanw1998@gmail.com");
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _googleAuth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  Future<User> _handleSignIn() async {
    User user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _googleAuth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _googleAuth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    User user = await _handleSignIn();
    SharedPreferences googleUid = await SharedPreferences.getInstance();
    googleUid.setString('googleUid', user.uid);
    print(user.uid);
    var userSignedIn = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => home_view()),
    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
  }

  void insertData() async {
    Map<String, dynamic> row = {
      databaseHelper.columnFirstName: fistNameController.text,
      databaseHelper.columnLastName: lastNameController.text,
      databaseHelper.columnEmailId: emailController.text,
      databaseHelper.columnDOB: selectedDate.toString(),
      databaseHelper.columnInsertedDate: insertedDate,
    };
    final id = await dbhelper.insert(row);
    print(id);
    pr.show();
    Future.delayed(Duration(seconds: 2)).then((value) {
      pr.hide().whenComplete(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => home_view()));
      });
    });
    //       Future.delayed(Duration(seconds: 4)).then((value) {
    //         pr.hide().whenComplete(() {
    //           Navigator.of(context).pushReplacement(
    //               MaterialPageRoute(
    //                   builder: (context) => home_view()));
  }

  Future<void> sendSignInLinkToEmail(String email,
      [ActionCodeSettings actionCodeSettings]) {
    try {
      return _auth.sendSignInLinkToEmail(email: email);
    } catch (e) {
      print("This is Exception" + e);
    }
  }

  Future<void> _signInWithEmailAndLink() async {
    email = emailController.text;
    return await _auth
        .signInWithEmailLink(
            email: "roshanw1998@gmail.com", emailLink: "roshanw1998@gmail.com")
        .catchError(
            (onError) => print('Error signing in with email link $onError'))
        .then((value) {
      var userEmail = value.user;
      print(userEmail);
      print("successfully signed in with email and password");
    });
  }

  Future<void> _emailSignIn() async {
    email = "roshanw1998@gmail.com";
    return await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
            url: 'https://flutterauth.page.link/',
            handleCodeInApp: true,
            androidPackageName: 'com.example.aarti_sangraha',
            androidMinimumVersion: '1'));
  }

  checkConnectivity() async {
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

  Future<void> _resisterInFirestore() async {
    firestoreInstance.collection("Users").add({
      "First_name": fistNameController.text,
      "Last_name": lastNameController.text,
      "email": emailController.text,
      "DOB": selectedDate.toString(),
      "Inserted_date": insertedDate
    }).then((value) {
      pr.show();
      Future.delayed(Duration(seconds: 2)).then((value) {
        pr.hide().whenComplete(() {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => home_view()));
        });
      });
      fistNameController.clear();
      lastNameController.clear();
      emailController.clear();
    }).catchError((onError) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Please check your Internet Connection!!!"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            );
          });
    });
  }

  void queryall() async {
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      print(row);
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1980),
      lastDate: new DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
    }
  }

  skipAlert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warning!!!"),
            content:
                Text("If you skipped you won't get your favourite list..."),
            actions: [
              FlatButton(
                child: Text(
                  "skip",
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => home_view()));
                },
              ),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ))
            ],
          );
        });
  }

  // Widget registrationFailed(BuildContext context) {
  //   var alertDialog = AlertDialog(
  //     title: Text("Registration Failed."),
  //     content: Text("Please check your Internet Connection!!"),
  //     actions: [
  //       Align(
  //         alignment: Alignment.bottomCenter,
  //         child: FlatButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text("Close")),
  //       )
  //     ],
  //   );
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return alertDialog;
  //       });
  // }

  // Widget loader(){
  //   return loader(
  //     Loading(
  //       indicator: BallPulseIndicator(),size: 100.0,
  //     )
  //   );
  // }

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

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 60.0,
            left: 40.0,
            right: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Text(
                  "Register",
                  style: TextStyle(
                      foreground: Paint()..shader = linearGradient,
                      fontSize: 30.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: fistNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter First Name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "First Name",
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0x73000000)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF00BCD4)),
                    ),
                  ),
                  maxLength: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: lastNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Last Name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0x73000000)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF00BCD4)),
                    ),
                  ),
                  maxLength: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "PLease enter email";
                    }
                    if (!EmailValidator.validate(value)) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email Id",
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0x73000000)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF00BCD4)),
                    ),
                  ),
                  maxLength: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "DOB: ",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(fontSize: 18.0, color: Colors.blue),
                        ),
                        IconButton(
                            tooltip: 'Tap to select Date',
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              _selectDate(context);
                            })
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: MaterialButton(
                    elevation: 10.0,
                    minWidth: 140.0,
                    height: 40.0,
                    splashColor: Colors.white,
                    color: Colors.blue,
                    child: Text(
                      "Submit",
                      style: btnStyle,
                    ),
                    onPressed: () async {
                      try {
                        if (formKey.currentState.validate()) {
                          _resisterInFirestore();
                        }
                      } catch (Exception) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Please check your Internet Connection!!!"),
                              );
                            });
                      }

                      // try {
                      //   if (formKey.currentState.validate()) {
                      //     // send = true;
                      //     dbRef.push().set({
                      //       "First Name": fistNameController.text,
                      //       "Last Name": lastNameController.text,
                      //       "DOB": selectedDate.toString(),
                      //       "Email": emailController.text,
                      //     }).then((_) {
                      //       print("Data Added");
                      //       pr.show();
                      //       Future.delayed(Duration(seconds: 4)).then((value) {
                      //         pr.hide().whenComplete(() {
                      //           Navigator.of(context).pushReplacement(
                      //               MaterialPageRoute(
                      //                   builder: (context) => home_view()));
                      //         });
                      //       });
                      //       fistNameController.clear();
                      //       lastNameController.clear();
                      //       emailController.clear();
                      //     }).catchError((onError) {
                      //       print(onError);
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return AlertDialog(
                      //               title: Text("Registration Failed"),
                      //             );
                      //           });
                      //     });
                      //   }
                      // } catch (Exception) {
                      //   showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: Text("Registration Failed"),
                      //         );
                      //       });
                      // }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: FlatButton(
                    splashColor: Colors.transparent,
                    child: Text(
                      "Skip",
                      style: TextStyle(fontSize: 18.0, color: Colors.black54),
                    ),
                    onPressed: () async {
                      skipAlert();
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: Text("Warninig"),
                      //       );
                      //     });
                    }),
              ),

              RaisedButton(
                padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
                color: const Color(0xFFFFFFFF),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "lib/asset/logo/Google_logo.png",
                              height: 30.0,
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
                onPressed: () {
                  onGoogleSignIn(context);
                },
              )
              // Padding(
              //   padding: EdgeInsets.only(top: 10.0),
              //   child: Text('$name' + '$lastName' + '$email'),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
