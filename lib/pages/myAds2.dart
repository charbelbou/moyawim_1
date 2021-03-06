import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'myAds.dart';
import 'myAppAds.dart';
import 'myCompletedAds.dart';
import 'adsInProgess.dart';
import 'package:moyawim/pages/drawer.dart';

Widget showMyAds() {
  return Container(
    margin: EdgeInsets.only(top: 10.0),
    height: 30,
    width: 120,
    child: Center(
      child: Text(
        "Posted",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontFamily: 'Raleway'),
      ),
    ),
  );
}

Widget showAppAds() {
  return Container(
    margin: EdgeInsets.only(top: 10.0),
    height: 30,
    width: 120,
    child: Center(
      child: Text(
        "In Progress",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontFamily: 'Raleway'),
      ),
    ),
  );
}

Widget showCompAppAds() {
  return Container(
    margin: EdgeInsets.only(top: 10.0),
    //padding: EdgeInsets.only(right: 50.0),
    height: 30,
    width: 120,
    child: Center(
      child: Text(
        "Completed",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontFamily: 'Raleway'),
      ),
    ),
  );
}

Widget showHighlight(bool isCurrentPageSelected) {
  return Container(
    margin: EdgeInsets.only(bottom: 30.0),
    height: 1,
    width: 120,
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
              color: isCurrentPageSelected ? Colors.white : Colors.black,
            ),
            top: BorderSide(color: Colors.white))),
  );
}

class Indicator extends StatelessWidget {
  Indicator({
    this.controller,
    this.itemCount: 0,
  }) : assert(controller != null);

  final PageController controller;
  final int itemCount;
  final Color normalColor = Colors.black;
  final Color selectedColor = Colors.grey;
  final double size = 100.0;
  final double spacing = 20.0;

  Widget _buildIndicator(
      int index, int pageCount, double size, double spacing) {
    bool isCurrentPageSelected = index ==
        (controller.page != null ? controller.page.round() % pageCount : 0);

    return showHighlight(isCurrentPageSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, spacing);
      }),
    );
  }
}

class myAds2 extends StatefulWidget {
  final String uid;

  myAds2({this.uid});

  @override
  _myAds2 createState() => _myAds2();
}

class _myAds2 extends State<myAds2> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    void _pageChanged(int index) {
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Ads",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        drawer: drawer(widget.uid, "myAds"),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 12,
              child: PageView(
                onPageChanged: _pageChanged,
                controller: controller,
                children: <Widget>[
                  myAds(uid: widget.uid),
                  inProgress(uid: widget.uid),
                  completedAppAds(uid: widget.uid)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[showMyAds(), showAppAds(), showCompAppAds()],
              ),
            ),
            Expanded(
              flex: 1,
              child: Indicator(
                controller: controller,
                itemCount: 3,
              ),
            ),
          ],
        ));
  }
}
