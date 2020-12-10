import 'dart:io';
import 'package:aarti_sangraha/Screens/aboutUs_view.dart';
import 'package:aarti_sangraha/Screens/favouriteAarti_view.dart';
import 'package:aarti_sangraha/Screens/home_view.dart';
import 'package:flutter/material.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 100.0,
            ),
            ListTile(
              selected: true,
              leading: Icon(Icons.home, color: Color(0xFFF06701)),
              // trailing: Icon(Icons.text_fields),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => home_view()));
              },
              title: Text(
                "Home",
                style: TextStyle(color: Color(0xFFF06701)),
              ),
            ),
            ListTile(
              selected: true,
              leading: Icon(Icons.favorite, color: Color(0xFFF06701)),
              // trailing: Icon(Icons.text_fields),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => favouriteAarti_view()));
              },
              title: Text(
                "Favourite Aartis",
                style: TextStyle(color: Color(0xFFF06701)),
              ),
            ),
            ListTile(
              selected: true,
              leading: Icon(Icons.folder_open, color: Color(0xFFF06701)),
              // trailing: Icon(Icons.text_fields),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => aboutUs_view()));
              },
              title: Text(
                "About us",
                style: TextStyle(color: Color(0xFFF06701)),
              ),
            ),
            Divider(
              color: Color(0xFFF06701),
            ),
            ListTile(
              selected: true,
              leading: Icon(Icons.exit_to_app, color: Color(0xFFF06701)),
              title: Text(
                "Exit",
                style: TextStyle(color: Color(0xFFF06701)),
              ),
              onTap: () {
                exit(0);
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
