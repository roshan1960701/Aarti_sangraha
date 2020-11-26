import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
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
  final fireStoreInstance = FirebaseFirestore.instance;
  final dbHelper = databaseHelper.instance;
  final TextEditingController fistNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _googleAuth;

  bool ignorePointer = false;
  bool isUserSignedIn = false;
  bool dateCheck = false;
  ProgressDialog progressDialog;
  DateTime selectedDate = DateTime.now();
  String insertedDate = DateTime.now().toString();
  DateTime newDate = DateTime.now();

  TextStyle btnStyle = new TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20.0);

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.purple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    checkConnectivity();
    initApp();
    super.initState();
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
    // SharedPreferences googleUid = await SharedPreferences.getInstance();
    // googleUid.setString('userId', user.uid);

    // DocumentReference documentReference =
    //     fireStoreInstance.collection("Users").doc(user.uid);
    // print(documentReference.id);

    /*fireStoreInstance
        .collection("Users")
        .add({
          "First_name": name[0],
          "Last_name": name[1],
          "email": user.email,
          "DOB": " ",
          "Inserted_date": insertedDate
        })
        .then((value) => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => home_view())),
              _googleSignIn.signOut()
            })
        .catchError((onError) {
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
        });*/

    // var userSignedIn = await Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => home_view()),
    // );
    //
    // setState(() {
    //   isUserSignedIn = userSignedIn == null ? true : false;
    // });
  }

  void insertData() async {
    Map<String, dynamic> row = {
      databaseHelper.columnFirstName: fistNameController.text,
      databaseHelper.columnLastName: lastNameController.text,
      databaseHelper.columnEmailId: emailController.text,
      databaseHelper.columnDOB: selectedDate.toString(),
      databaseHelper.columnInsertedDate: insertedDate,
    };
    final id = await dbHelper.insert(row);
    print(id);
    progressDialog.show();
    Future.delayed(Duration(seconds: 2)).then((value) {
      progressDialog.hide().whenComplete(() {
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

  registerUser(String fName, String lName, String email, String dob,
      String insertedDate) async {
    var userID;
    fireStoreInstance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        userID = element.id;
      });
      if (userID == null) {
        progressDialog.show();
        Future.delayed(Duration(seconds: 1)).then((value) async {
          progressDialog.hide().whenComplete(() async {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => home_view()));
          });
        });
        fireStoreInstance.collection("Users").add({
          "First_name": fName,
          "Last_name": lName,
          "email": email,
          "DOB": dob,
          "Inserted_date": insertedDate
        }).then((value) async {
          userID = value.id;
          SharedPreferences googleUid = await SharedPreferences.getInstance();
          googleUid.setString('userId', userID);
        }).catchError((onError) async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Please check your Internet Connection!!!"),
                  actions: [
                    FlatButton(
                        onPressed: () async {
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
      } else {
        progressDialog.show();
        Future.delayed(Duration(seconds: 1)).then((value) async {
          progressDialog.hide().whenComplete(() async {
            SharedPreferences googleUid = await SharedPreferences.getInstance();
            googleUid.setString('userId', userID);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => home_view()));
          });
        });
      }
    });
  }

  Future<void> registerInFireStore() async {
    var userID;
    var userDocId;
    String email;
    fireStoreInstance
        .collection("Users")
        .where("email", isEqualTo: emailController.text)
        .get()
        .then((value) async => {
              value.docs.forEach((element) {
                // print(element.data());
                email = element.data()["email"];
                userDocId = element.id;
              }),
              if (emailController.text == email)
                {
                  progressDialog.show(),
                  Future.delayed(Duration(seconds: 2)).then((value) {
                    progressDialog.hide().whenComplete(() async {
                      userID = userDocId;
                      SharedPreferences googleUid =
                          await SharedPreferences.getInstance();
                      googleUid.setString('userId', userID);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => home_view()));
                    });
                  }),
                }
              else
                {
                  progressDialog.show(),
                  Future.delayed(Duration(seconds: 2)).then((value) {
                    progressDialog.hide().whenComplete(() async {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => home_view()));
                    });
                  }),
                  fireStoreInstance.collection("Users").add({
                    "First_name": fistNameController.text,
                    "Last_name": lastNameController.text,
                    "email": emailController.text,
                    "DOB": selectedDate.toString(),
                    "Inserted_date": insertedDate
                  }).then((value) async {
                    userID = value.id;
                    SharedPreferences googleUid =
                        await SharedPreferences.getInstance();
                    googleUid.setString('userId', userID);
                  }).catchError((onError) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                "Please check your Internet Connection!!!"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text(
                                    "Close",
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
                          );
                        });
                  }),
                }
            });
  }

  void queryall() async {
    var allrows = await dbHelper.queryall();
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
                onPressed: () async {
                  SharedPreferences googleUid =
                      await SharedPreferences.getInstance();
                  googleUid.setString('userId', "SKIPID0012345");
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
          body: IgnorePointer(
            ignoring: false,
            // ignoring: ignorePointer,
            child: Form(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Color(0x73000000)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Color(0x73000000)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Color(0x73000000)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
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
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blue),
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
                    Text(
                      dateCheck ? "Age must be greater that 5 years " : " ",
                      style: TextStyle(color: Colors.red),
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
                                if (newDate.year.toInt() -
                                        selectedDate.year.toInt() >=
                                    5) {
                                  setState(() {
                                    dateCheck = false;
                                    //   ignorePointer = true;
                                  });
                                  //registerInFireStore();
                                  registerUser(
                                      fistNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      selectedDate.toString(),
                                      insertedDate);
                                } else {
                                  setState(() {
                                    dateCheck = true;
                                  });
                                }
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
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.black54),
                          ),
                          onPressed: () async {
                            skipAlert();
                          }),
                    ),
                    RaisedButton(
                      padding:
                          EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
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
                      onPressed: () async {
                        setState(() {
                          ignorePointer = true;
                        });
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => home_Page()));
                        User user = await _handleSignIn();
                        var name = new List();
                        name = user.displayName.split(" ");
                        registerUser(
                            name[0], name[1], user.email, " ", insertedDate);
                        _googleSignIn.signOut();
                        // onGoogleSignIn(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
