import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/utilities.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  utilities util = new utilities();
  FirebaseAuth _googleAuth;
  bool ignorePointer = false;
  bool isUserSignedIn = false;
  bool dateCheck = false;
  ProgressDialog progressDialog;
  DateTime selectedDate = DateTime.now();
  String insertedDate = DateTime.now().toString();
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    initApp();
    Future.delayed(Duration.zero, () {
      util.checkConnectivity(context);
    });
    super.initState();
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _googleAuth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
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

  Widget formTextFields(controller, inputType, validator, lengthValidator) {
    return TextFormField(
      autovalidate: true,
      validator: (value) {
        if (value.isEmpty) {
          return validator;
        }
        if (value.length > 15) {
          return lengthValidator;
        }
        return null;
      },
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: Color(0x73000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: Color(0xFFFF8C00)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: Color(0x73000000)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide(color: Color(0xFFFF8C00)),
        ),
      ),
      maxLength: 15,
    );
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

  /*void insertData() async {
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
  }*/

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
                  setState(() {
                    ignorePointer = true;
                  });
                  SharedPreferences googleUid =
                      await SharedPreferences.getInstance();
                  googleUid.setString('userId', "SKIPID0012345");
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setStringList("Fav", [" "]);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => home_view()));
                },
              ),
              FlatButton(
                  color: Color(0xFFF06701),
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
          appBar: AppBar(
            elevation: 10.0,
            centerTitle: true,
            title: Text("Register",
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20.0, color: Colors.white)),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF06701), Color(0xFFFF8804)])),
            ),
          ),
          body: IgnorePointer(
            ignoring: ignorePointer,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 40.0,
                    right: 40.0,
                  ),
                  child: Column(
                    children: [
                      formText("First Name"),
                      formTextFields(
                          fistNameController,
                          TextInputType.text,
                          "Please Enter First Name",
                          "First Name should not be greater than 15 character"),
                      formText("Last Name"),
                      formTextFields(
                          lastNameController,
                          TextInputType.text,
                          "Please Enter Last Name",
                          "Last Name should not be greater than 15 character"),
                      formText("Email"),
                      TextFormField(
                        autovalidate: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter email";
                          }
                          if (value.length > 30) {
                            return "Email should not be grater that 30 character";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Please Enter valid email";
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            borderSide: BorderSide(color: Color(0x73000000)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            borderSide: BorderSide(color: Color(0xFFFF8C00)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            borderSide: BorderSide(color: Color(0x73000000)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            borderSide: BorderSide(color: Color(0xFFFF8C00)),
                          ),
                        ),
                        maxLength: 30,
                        maxLengthEnforced: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(color: Color(0x73000000))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  formText("DOB"),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0x73000000)),
                                  ),
                                  IconButton(
                                      tooltip: 'Tap to select Date',
                                      icon: Icon(
                                        Icons.calendar_today_rounded,
                                      ),
                                      onPressed: () {
                                        _selectDate(context);
                                      })
                                ],
                              )),
                        ),
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
                            height: 40.0,
                            child: Container(
                              height: 40.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 120.0, vertical: 10.0),
                              child: Text(
                                "Submit",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontStyle: FontStyle.normal),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFF06701),
                                    Color(0xFFFF8804)
                                  ])),
                            ),
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                if (currentDate.year.toInt() -
                                        selectedDate.year.toInt() >=
                                    5) {
                                  setState(() {
                                    ignorePointer = true;
                                    dateCheck = false;
                                  });
                                  //registerInFireStore();
                                  registerUser(
                                      fistNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      selectedDate.toString(),
                                      insertedDate);

                                  print(fistNameController.text);
                                  print(lastNameController.text);
                                  print(emailController.text);
                                  print(selectedDate.toString());
                                  print(insertedDate);
                                } else {
                                  setState(() {
                                    dateCheck = true;
                                  });
                                }
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: FlatButton(
                            splashColor: Colors.transparent,
                            child: Text(
                              "Skip",
                              style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                  fontStyle: FontStyle.normal),
                            ),
                            onPressed: () async {
                              skipAlert();
                            }),
                      ),
                      MaterialButton(
                        height: 40.0,
                        child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            height: 40.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFF06701),
                                  Color(0xFFFF8804)
                                ])),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "asset/logo/Google_logo.png",
                                  height: 30.0,
                                  width: 30.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Sign in with Google",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            )),
                        onPressed: () async {
                          User user = await _handleSignIn();
                          var name = new List();
                          name = user.displayName.split(" ");
                          registerUser(
                              name[0], name[1], user.email, " ", insertedDate);
                          _googleSignIn.signOut();
                          setState(() {
                            ignorePointer = true;
                          });
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
      ),
    );
  }

  @override
  void dispose() {
    fistNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
