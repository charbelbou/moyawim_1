import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:moyawim/services/auth.dart';

import '../loader.dart';
import 'latestads.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot ad;

  DetailPage({this.ad});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future _data;

  Future getAds() async {
    var fs = Firestore.instance;
    QuerySnapshot qn = await fs.collection("ads").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    _data = getAds();
  }

  navigateToDetail(DocumentSnapshot ad) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailPage(ad: ad)));
  }

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final mainTag = widget.ad.data["tags"][0];

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ColorLoader(),
                );
              } else {
                return Container(
                    child: ListView(children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(3.0),
                      height: 230.0,
                      width: 600.0,
                      child: Card(
                        color: Colors.cyan,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.lightbulb_outline, color: Colors.black),
                            Text(
                              (widget.ad.data["tags"][0]),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Raleway'),
                            )
                          ],
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (widget.ad.data["title"]),
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontFamily: 'Raleway', fontSize: 30.0),
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.only(left: 10.0, top: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("Price \$" + widget.ad.data["price"]),
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontFamily: 'Raleway', fontSize: 25.0),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
                    height: 60.0,
                    width: 400.0,
                    child: Card(
                        color: Colors.deepOrangeAccent,
                        child: Center(
                          child: Text(
                            "Take Ad",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    margin: EdgeInsets.only(top: 0.0, bottom: 5.0),
                    height: 60.0,
                    width: width,
                    child: Card(
                        color: Colors.indigoAccent,
                        child: Center(
                          child: Text(
                            "Add to list",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10.0, top: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("Ad Information"),
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontFamily: 'Raleway', fontSize: 25.0),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 3.0, right: 3.0),
                      width: width,
                      height: 250.0,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 5.0, left: 3.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Description",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 20.0),
                                    ))),
                            Container(
                              width: width,
                              height: 100.0,
                              padding: EdgeInsets.all(4.0),
                              child: Card(
                                color: Colors.black12,
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Text(
                                      (widget.ad.data["description"] + ""),
                                      maxLines: 99,
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 15.0),
                                    )),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5.0, left: 3.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Location",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 20.0),
                                    ))),
                            Container(
                              width: width,
                              height: 60.0,
                              padding: EdgeInsets.all(4.0),
                              child: Card(
                                color: Colors.black12,
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Text(
                                      (widget.ad.data["location"]),
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 15.0),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("Similar Ads"),
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontFamily: 'Raleway', fontSize: 25.0),
                        ),
                      )),
                  Container(
                    child: Container(
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        height: height * 0.267,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 14,
                          itemBuilder: (context, index) {
                            if ((snapshot.data[index].data["tags"][0] ==
                                    mainTag) &&
                                (snapshot.data[index].documentID !=
                                    widget.ad.documentID)) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: GestureDetector(
                                    onTap: () =>
                                        navigateToDetail(snapshot.data[index]),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: GestureDetector(
                                          child: Column(children: <Widget>[
                                            Expanded(
                                                flex: 5,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6.0,
                                                                    right: 6.0,
                                                                    top: 6.0),
                                                            child: Container(
                                                                height: height *
                                                                    0.3,
                                                                child: Card(
                                                                  color: Colors
                                                                      .white60,
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .data["title"],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0,
                                                                          fontFamily:
                                                                              'Raleway',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    subtitle:
                                                                        Text(
                                                                      "Price \$" +
                                                                          snapshot
                                                                              .data[index]
                                                                              .data["price"],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0,
                                                                          fontFamily:
                                                                              'Raleway'),
                                                                    ),
                                                                  ),
                                                                )))),
                                                  ],
                                                )),
                                            Expanded(
                                                flex: 7,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: width *
                                                                      0.021,
                                                                  left: width *
                                                                      0.021,
                                                                  right: width *
                                                                      0.021,
                                                                  bottom: width *
                                                                      0.027),
                                                          child:
                                                              GestureDetector(
                                                                  child:
                                                                      Container(
                                                            height:
                                                                height * 0.3,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color: _color(),
                                                            ),
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
                                                                        .white),
                                                                Text(
                                                                  (snapshot.data[index].data["tags"][0]
                                                                              [
                                                                              0])
                                                                          .toUpperCase() +
                                                                      (snapshot
                                                                          .data[
                                                                              index]
                                                                          .data[
                                                                              "tags"]
                                                                              [
                                                                              0]
                                                                          .substring(
                                                                              1)),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          'Raleway'),
                                                                )
                                                              ],
                                                            ),
                                                          ))),
                                                    ),
                                                  ],
                                                ))
                                          ]),
                                        ))),
                              );
                            } else {
                              return Text("");
                            }
                          },
                        )),
                  )
                ]));
              }
              ;
            }));
  }
}
