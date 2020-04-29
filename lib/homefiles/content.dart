import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moyawim/services/auth.dart';

import '../homefiles/resultpage.dart';
import '../homefiles/latestads.dart';
import '../homefiles/search.dart';
import 'detailpage.dart';

class Content extends StatefulWidget {
  final String uid;
  Content(this.uid);
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    Future _data;

    Future getAds() async {
      var fs = Firestore.instance;

      QuerySnapshot qn = await fs.collection("ads").getDocuments();

      return qn.documents;
    }

    navigateToDetail(DocumentSnapshot ad) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DetailPage(ad: ad,uid: widget.uid)));
    }

    @override
    void initState() {
      super.initState();

      _data = getAds();
    }

    List colors = [
      Color(0xFFFD7384),
      Color(0xFF2BD093),
      Color(0xFFFc7B4D),
      Color(0xFF53CEDB),
      Color(0xFFF1B069)
    ];

    String searchTag = "housework";
    String searchTag2 = "driving";
    String searchTag3 = "technology";
    String searchTag4 = "education";

    navigateToResult(String st,String uid) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResultPage(st: st,uid:uid)));
    }

    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1000.0),
        child: Column(
          //shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    CreateSearchView(uid: widget.uid),
                    Row(
                      children: <Widget>[
                        Text(
                          "Explore",
                          style: TextStyle(fontSize: 30.0, fontFamily: 'Raleway'),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: GestureDetector(
                                  onTap: () {
                                    navigateToResult(searchTag,widget.uid);
                                  },
                                  child: Container(
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xFFFD7384),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.account_balance,
                                            color: Colors.white),
                                        Text(
                                          "House Work",
                                          style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                                        )
                                      ],
                                    ),
                                  ))),
                        ),
                        Expanded(
                          child: Container(
                            height: 100.0,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 2.5, right: 2.5),
                                        child: GestureDetector(
                                            onTap: () {
                                              navigateToResult(searchTag2,widget.uid);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF2BD093),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Icon(
                                                          Icons.directions_car,
                                                          color: Colors.white)),
                                                  Text(
                                                    "Driving",
                                                    style: TextStyle(
                                                        color: Colors.white, fontFamily: 'Raleway'),
                                                  )
                                                ],
                                              ),
                                            )))),
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 2.5, right: 2.5),
                                        child: GestureDetector(
                                            onTap: () {
                                              navigateToResult(searchTag3,widget.uid);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFc7B4D),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 3.0, right: 2.0),
                                                      child: Icon(
                                                          Icons.computer,
                                                          color: Colors.white))),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Text(
                                                    "Technology",
                                                    style: TextStyle(
                                                        color: Colors.white, fontFamily: 'Raleway')),
                                                  )
                                                ],
                                              ),
                                            )))),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100.0,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 2.5, left: 2.5),
                                        child: GestureDetector(
                                            onTap: () {
                                              navigateToResult(searchTag4,widget.uid);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF53CEDB),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Icon(Icons.school,
                                                          color: Colors.white)),
                                                  Text(
                                                    "Education",
                                                    style: TextStyle(
                                                        color: Colors.white, fontFamily: 'Raleway'),
                                                  )
                                                ],
                                              ),
                                            )))),
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 2.5, left: 2.5),
                                        child: GestureDetector(
                                            onTap: () {
                                              navigateToResult("all",widget.uid);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF1B069),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Icon(
                                                          Icons.art_track,
                                                          color: Colors.white, )),
                                                  Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors.white, fontFamily: 'Raleway'),
                                                  )
                                                ],
                                              ),
                                            )))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ));
  }
}
