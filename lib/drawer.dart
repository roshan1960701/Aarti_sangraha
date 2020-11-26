import 'dart:io';
import 'package:aarti_sangraha/Screens/aboutUs_view.dart';
import 'package:aarti_sangraha/Screens/favouriteAarti_view.dart';
import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:flutter/material.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100.0,
          ),
          ListTile(
            selected: true,
            leading: Icon(Icons.home),
            // trailing: Icon(Icons.text_fields),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => home_view()));
            },
            title: Text("Home"),
          ),
          ListTile(
            selected: true,
            leading: Icon(Icons.favorite),
            // trailing: Icon(Icons.text_fields),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => favouriteAarti_view()));
            },
            title: Text("Favourite Aartis"),
          ),
          ListTile(
            selected: true,
            leading: Icon(Icons.folder_open),
            // trailing: Icon(Icons.text_fields),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => aboutUs_view()));
            },
            title: Text("About us"),
          ),
          Divider(),
          ListTile(
            selected: true,
            leading: Icon(Icons.exit_to_app),
            title: Text("Exit"),
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
    ;
  }
}
