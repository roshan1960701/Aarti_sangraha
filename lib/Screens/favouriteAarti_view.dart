import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:aarti_sangraha/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class favouriteAarti_view extends StatefulWidget {
  favouriteAarti_view({Key key}) : super(key: key);

  @override
  _favouriteAarti_viewState createState() => _favouriteAarti_viewState();
}

class _favouriteAarti_viewState extends State<favouriteAarti_view> {
  var name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => home_view()));
            }),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? Firestore.instance
                .collection('Aartis')
                .orderBy("name_english")
                .startAt([name]).endAt([name + "\uf88f"]).snapshots()
            : Firestore.instance.collection("Aartis").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return Card(
                      elevation: 10.0,
                      color: Colors.blueGrey,
                      child: Wrap(
                        children: <Widget>[
                          Image.network(
                            data['image'],
                            width: 120,
                            height: 80,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            data['name_marathi'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
