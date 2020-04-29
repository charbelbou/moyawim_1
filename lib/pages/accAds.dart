import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_color/random_color.dart';

import 'acceptedAdsDetail.dart';
import 'package:moyawim/homefiles/detailpage.dart';
import 'package:moyawim/pages/drawer.dart';
import 'package:moyawim/homefiles/resultpage.dart';
import '../loader.dart';

class accAds extends StatefulWidget {
  final String uid;

  accAds({this.uid});

  @override
  _accAdsState createState() => _accAdsState();
}

class _accAdsState extends State<accAds> {

  navigateToDetail(DocumentSnapshot ad) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => acceptedAdsDetail(
              ad: ad,
              uid: widget.uid,
            )));
  }

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  bool isMyAdd = false;
  bool isEmpty = false;
  bool isImage = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection("ads")
                  .where("worker", isEqualTo: widget.uid).where("phase",isEqualTo: 2)
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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

                  return !isEmpty
                      ? Container(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          void check() {
                            if (snapshot
                                .data.documents[index].data["poster"] ==
                                widget.uid) {
                              isMyAdd = true;
                            }
                            var len1 = snapshot.data.documents[index].data["urls"];
                            int len;
                            if(len1 != null){
                              int len = snapshot.data.documents[index].data["urls"].length;
                              if(len != 0){
                                isImage = true;
                              }
                              else{
                                isImage = false;
                              }
                            }
                          }

                          check();

                          return Container(
                              child: Column(children: <Widget>[
                                GestureDetector(
                                  onTap: () => navigateToDetail(
                                      snapshot.data.documents[index]),
                                  child: Container(
                                      height: 180.0,
                                      child: Card(
                                          color: Colors.white12,
                                          child: CustomListItemTwo(
                                              thumbnail: Container(
                                                  margin: EdgeInsets.all(3.0),
                                                  height: 100.0,
                                                  width: 100.0,
                                                  child: !isImage
                                                      ? Card(
                                                    color: _color(),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Icon(
                                                            Icons
                                                                .lightbulb_outline,
                                                            color: Colors
                                                                .black),
                                                        Text(
                                                          (snapshot.data.documents[index].data["tags"][0]),
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
                                                      child: Image.network(
                                                        snapshot.data.documents[index].data["urls"][0],
                                                        height: 100.0,
                                                        width: 100.0,
                                                        fit: BoxFit.cover,
                                                        filterQuality: FilterQuality.low,
                                                        loadingBuilder: (BuildContext context, Widget child,
                                                            ImageChunkEvent loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return Center(
                                                            child: ColorLoader(),
                                                          );
                                                        },
                                                      ))),
                                              title: snapshot.data
                                                  .documents[index].data["title"],
                                              subtitle: snapshot
                                                  .data
                                                  .documents[index]
                                                  .data["description"],
                                              author: snapshot
                                                  .data
                                                  .documents[index]
                                                  .data["location"],
                                              //publishDate: 'Dec 28',
                                              readDuration: Container(
                                                child: Text(
                                                  "In Progress",

                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: 'Raleway',
                                                    color: Colors.green,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              price: "Price \$" +
                                                  snapshot.data.documents[index]
                                                      .data["price"]))),
                                ),
                              ]));
                        },
                      ))
                      : Container(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                "You have not been accepted for any Ads yet...",
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
              }),
        ));
  }
}
