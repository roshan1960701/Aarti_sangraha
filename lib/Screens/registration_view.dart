import 'dart:html';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';


class registration_view extends StatefulWidget {
  registration_view({Key key}) : super(key: key);

  @override
  _registration_viewState createState() => _registration_viewState();
}

class _registration_viewState extends State<registration_view> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  final TextEditingController fistNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool send = false;

  TextStyle btnStyle = new TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20.0);

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blue, Colors.purple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1980),
      lastDate: new DateTime.now(),
    );
    // selectedDate = picked;

    if (picked != null && picked != selectedDate &&) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        // var now = new DateTime.now();
        // var formatter = new DateFormat('yyyy-MM-dd');
        // String formattedDate = formatter.format(now);
        // select = selectedDate.toString();
      });
    }
  } 
  // Widget showDialog(
  //   context: context,
  //   builder: (BuildContext context){
  //       return AlertDialog(
  //         title: Text("Alert Dialog"),
  //         content: Text("Dialog Content"),
  //       );
  //   }
  // )
  // Widget showDialog(){

  //   builder: (BuildContext context){
  //       return AlertDialog(
  //         title: Text("Registration Failed"),
  //         content: Text("Please check your Internet connection"),
  //         actions: [
  //           FlatButton(onPressed: (){
  //             Navigator.pop(context);
  //           }, child: Text("close"))
  //         ],

  //       );
  //   };
  // }

  void msg(BuildContext context){
      var alertDialog = AlertDialog(
        title: Text("Alert Dialog"),
        content: Text("Are you sure?"),

      );
      showDialog(context: context,
      builder: (BuildContext context){
        return alertDialog;
      }
      
    );

    }

  // Widget loader(){
  //   return loader(
  //     Loading(
  //       indicator: BallPulseIndicator(),size: 100.0,
  //     )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        send = true;
                        dbRef.push().set({
                          "First Name":fistNameController.text,
                          "Last Name": lastNameController.text,
                          "DOB":selectedDate.toString(),
                          "Email":emailController.text,
                        })  .then((_){
                           print("Data Added");
                            fistNameController.clear();
                            lastNameController.clear();
                            emailController.clear();
                        } ).catchError((onError){
                          print(onError);
                          AlertDialog(
                            title: Text("Registration Failed"),
                            content: Text("Please check your Internet connection"),
                            actions: [
                              FlatButton(
                                color: Colors.blue,
                                onPressed: (){}, child: Text("Close",style: TextStyle(color: Colors.white),))
                            ],
                          );
                        });
                      }
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
                    onPressed: () {
                      //showDialog();
                      msg(context);
                      //  AlertDialog(
                      //       title: Text("Registration Failed"),
                      //       content: Text("Please check your Internet connection"),
                      //       actions: [
                      //         FlatButton(
                      //           color: Colors.blue,
                      //           onPressed: (){}, child: Text("Close",style: TextStyle(color: Colors.white),))
                      //       ],
                      //     );
                    }),
              ),
                Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(send ? "Data Added Successfully" : " "),
              )
            ],
          ),
        ),
      ),
    );
  }

}
