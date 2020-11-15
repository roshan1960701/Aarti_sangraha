import 'package:aarti_sangraha/Screens/aartList_view.dart';
import 'package:aarti_sangraha/drawer.dart';
import 'package:flutter/material.dart';

class home_view extends StatefulWidget {
  home_view({Key key}) : super(key: key);

  @override
  _home_viewState createState() => _home_viewState();
}

class _home_viewState extends State<home_view> {
  // startTime() async {
  //   var duration = new Duration(seconds: 6);
  //   return new Timer(duration, route);
  // }

  // route() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => registration_view()));
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Column(
              children: [
                IconButton(icon: Icon(Icons.search), onPressed: () {})
              ],
            )
          ],
        ),
        drawer: drawer(),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          children: List.generate(40, (index) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => aartiList_view()));
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
