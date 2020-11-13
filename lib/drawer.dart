import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:flutter/material.dart';

class drawer extends StatefulWidget {
  drawer({Key key}) : super(key: key);

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
       child: Column(
         children: [
            ListTile(
           selected: true,
           leading: Icon(Icons.text_fields),
          // trailing: Icon(Icons.text_fields),
           onTap: (){
             Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => home_view())
             );
           },
           title: Text("Home"),
         ),
         ],
       ),
    );
  }
}