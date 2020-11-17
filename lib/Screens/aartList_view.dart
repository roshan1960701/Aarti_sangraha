import 'package:aarti_sangraha/Screens/specificAarti_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class aartiList_view extends StatefulWidget {
  List value;
  aartiList_view({Key key,this.value}) : super(key: key);
  

  @override
  _aartiList_viewState createState() => _aartiList_viewState(value);
}

class _aartiList_viewState extends State<aartiList_view> {
  List value;
  _aartiList_viewState(this.value);
 
final firestoreInstance = FirebaseFirestore.instance;
final firestoreInstanceSecond = FirebaseFirestore.instance;
var title,img;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getArtiSangraha();
    //ganeshAarti();
    //insertData();
    //queryall();
  }

  Future<QuerySnapshot> getArtiSangraha() async {
    firestoreInstance.collection("Aartis").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
        //print(result.data());
        //print(result.data()["id"]);
        if(result.data()["id"] == value){
          getListOfAarti();

        }

      });
      
  });
  }

  Future<QuerySnapshot> getListOfAarti() async{
    firestoreInstance.collection("Aartis").get().then((value) => 
          value.docs.forEach((element) {
            title = element.data()["title"];
            img = element.data()["image"];
           // print(element.data()["title"]);
          }
          )
          );
  }

 void ganeshAarti() async{
    firestoreInstanceSecond.collection("Aartis").where("category", arrayContains: "ganesh").get().then((value) => 
    value.docs.forEach((element) {
      print(element.data());
    })
    );


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        ),
        body: ListView.builder(
            itemCount: 40,  
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue[100], Colors.green[100]])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Image.network('$img'),
                        ),
                        SizedBox(width: 10,),
                        Text("$value",style: TextStyle(color: Colors.orange[900]),),

                    ],)
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => specificAarti_view()));
                },
              );
            }),
      ),
    );
  }
}
