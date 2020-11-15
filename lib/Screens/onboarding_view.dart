import 'package:aarti_sangraha/Model/sliderModel.dart';
import 'package:aarti_sangraha/Screens/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:aarti_sangraha/sliderTile.dart';

class onboarding_view extends StatefulWidget {
  onboarding_view({Key key}) : super(key: key);

  @override
  _onboarding_viewState createState() => _onboarding_viewState();
}

class _onboarding_viewState extends State<onboarding_view> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.orange[900] : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white, Colors.orange[600]])),
          // height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              sliderTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              sliderTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              sliderTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],
          ),
        ),
      ),
      bottomSheet: slideIndex != 2
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.orange[600]])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      controller.animateToPage(2,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    splashColor: Colors.blue[0],
                    child: Text(
                      "SKIP",
                      style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    child: Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          i == slideIndex
                              ? _buildPageIndicator(true)
                              : _buildPageIndicator(false),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print("this is slideIndex: $slideIndex");
                      controller.animateToPage(slideIndex + 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    splashColor: Colors.blue[50],
                    child: Text(
                      "NEXT",
                      style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => registration_view()));
              },
              child: Container(
                // height: Platform.isIOS ? 70 : 60,
                height: 60.0,
                alignment: Alignment.center,
                color: Colors.orange[600],
                child: Text(
                  "GET STARTED NOW",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }
}
