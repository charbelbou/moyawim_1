import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';

import 'package:flutter/material.dart';
import 'package:moyawim/services/auth.dart';
import 'dart:math';

import '../homefiles/detailpage.dart';
import '../loader.dart';
import '../homefiles/resultpage.dart';



class recommendedAds extends StatefulWidget {
  final String uid;

  recommendedAds(this.uid);

  @override
  _recommendedAdsState createState() => _recommendedAdsState();
}

class _recommendedAdsState extends State<recommendedAds> {
  String location;

  @override
  Widget getLocation(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(widget.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          location = snapshot.data['location'];
          return Text(
              "Near me in " + snapshot.data['location'],
            style: TextStyle(
                color: Colors.white, fontSize: 25.0, fontFamily: 'Raleway'),
            textAlign: TextAlign.left,);
        });
  }



  navigateToDetail(DocumentSnapshot ad, String uid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(ad: ad, uid: widget.uid)));
  }

  List colors = [
    Color(0xFFFD7384),
    Color(0xFF2BD093),
    Color(0xFFFc7B4D),
    Color(0xFF53CEDB),
    Color(0xFFF1B069)
  ];
  Random random = Random();

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  bool isMyAdd = false;
  bool isEmpty = false;
  bool isImage = false;

  Stream _data;
  final db = Firestore.instance;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(children: <Widget>[
      Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
            child: getLocation(context))
      ]),
      Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection("ads")
                .where("phase", isEqualTo: 1)
                .where("location", isEqualTo: location)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ColorLoader(),
                );
              } else {

                void checkIsEmpty(){
                  if((snapshot.data.documents.length == 0) || (snapshot.data.documents.length == null)){
                    isEmpty = true;
                  }
                  else{
                    isEmpty = false;
                  }
                }

                checkIsEmpty();

                return !isEmpty ? Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    height: 180,
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: ColorLoader(),
                            );
                          } else {
                            void checkEmpty() {
                              if (snapshot.data.documents.length == 0) {
                                isEmpty = true;
                              }
                            }

                            checkEmpty();

                            void check() {
                              if (snapshot
                                      .data.documents[index].data["poster"] ==
                                  widget.uid) {
                                isMyAdd = true;
                              }
                              var len1 =
                                  snapshot.data.documents[index].data["urls"];
                              int len;
                              if (len1 != null) {
                                int len = snapshot
                                    .data.documents[index].data["urls"].length;
                                if (len != 0) {
                                  isImage = true;
                                } else {
                                  isImage = false;
                                }
                              }
                            }

                            check();

                            return !isEmpty
                                ? Container(
                                    width: 350,
                                    child: Column(children: <Widget>[
                                      GestureDetector(
                                        onTap: () => navigateToDetail(
                                            snapshot.data.documents[index],
                                            widget.uid),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            margin: EdgeInsets.only(right: 7.0),
                                            height: 180.0,
                                            child: Card(
                                                color: Colors.white12,
                                                child: CustomListItemTwo(
                                                    thumbnail: Container(
                                                        margin:
                                                            EdgeInsets.all(3.0),
                                                        height: 100.0,
                                                        width: 100.0,
                                                        child: !isImage
                                                            ? Card(
                                                                color: _color(),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                        Icons
                                                                            .lightbulb_outline,
                                                                        color: Colors
                                                                            .black),
                                                                    Text(
                                                                      (snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data["tags"][0]),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              20.0,
                                                                          fontFamily:
                                                                              'Raleway'),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        5.0),
                                                                child: Image
                                                                    .network(
                                                                  snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["urls"][0],
                                                                  height: 100.0,
                                                                  width: 100.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          ColorLoader(),
                                                                    );
                                                                  },
                                                                ))),
                                                    title: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["title"],
                                                    subtitle: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["description"],
                                                    author: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["location"],
                                                    //publishDate: 'Dec 28',
                                                    readDuration: Container(),
                                                    price: "Price \$" +
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["price"]))),
                                      ),
                                    ]))
                                : Container(
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.grey,
                                                size: 100.0,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "You have not applied for any Ads yet...",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Raleway',
                                                    fontSize: 30.0,
                                                    color: Colors.grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          }
                        })):
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  width: width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius:
                      BorderRadius.circular(10.0)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.sentiment_dissatisfied),
                        Text(
                          "No ads near you",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ],
                    )
                  )
                );
              }
            }),
      )
    ]);
  }
}
