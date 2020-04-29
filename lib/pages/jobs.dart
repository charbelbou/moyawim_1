import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'myAds.dart';
import 'myAppAds.dart';
import 'appCompletedAds.dart';
import 'accAds.dart';
import 'package:moyawim/pages/drawer.dart';

Widget showMyAds() {
  return Container(
    margin: EdgeInsets.only(top: 10.0),
    height: 30,
    width: 120,
    child: Center(
      child: Text(
        "Applied",
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
        "Accepted",
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

class myJobs extends StatefulWidget {
  final String uid;

  myJobs({this.uid});

  @override
  _myJobsState createState() => _myJobsState();
}

class _myJobsState extends State<myJobs> {
  @override
  Widget build(BuildContext context) {

    final PageController controller = PageController(initialPage: 0);

    void _pageChanged(int index) {
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Jobs",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        drawer: drawer(widget.uid, "myJobs"),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 12,
              child: PageView(
                onPageChanged: _pageChanged,
                controller: controller,
                children: <Widget>[
                  myAppAds(uid: widget.uid),
                  accAds(uid: widget.uid),
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
