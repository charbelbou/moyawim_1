import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyawim/services/auth.dart';
import 'dart:math';

import 'detailpage.dart';
import '../loader.dart';


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getAds() async {
    var fs = Firestore.instance;
    QuerySnapshot qn = await fs.collection("ads").getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot ad) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailPage(ad: ad)));
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
  Random random = Random();

  int i = 0;

  void changeIndex() {
    setState(() {
      i = random.nextInt(3);
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    return Column(children: <Widget>[
      Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
            child: Text(
              "Latest Ads",
              style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'Raleway'),
              textAlign: TextAlign.left,
            ))
      ]),
      Container(
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ColorLoader(),
                );
              } else {
                return Container(
                    padding: EdgeInsets.only(left: 15.0, ),
                    height: height * 0.267,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                              onTap: () =>
                                  navigateToDetail(snapshot.data[index]),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
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
                                                  padding: EdgeInsets.only(left:6.0, right: 6.0, top: 6.0),
                                                  child: Container(
                                                      height: height * 0.3,
                                                      child: Card(
                                                    color: Colors.white60,
                                                    child: ListTile(
                                                      title: Text(
                                                        snapshot.data[index]
                                                            .data["title"],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        "Price \$" +
                                                            snapshot.data[index]
                                                                .data["price"],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                'Raleway'),
                                                      ),
                                                    ),
                                                  )))),
                                        ],
                                      )),

                                      Expanded (
                                          flex: 7,
                                          child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.only(top:width*0.021, left:width*0.021, right: width*0.021, bottom: width*0.027 ),
                                                child: GestureDetector(
                                                    child: Container(
                                                  height: height*0.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color: colors[index],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                          Icons
                                                              .lightbulb_outline,
                                                          color: Colors.white),
                                                      Text(
                                                        (snapshot.data[index]
                                                                            .data[
                                                                        "tags"]
                                                                    [0][0])
                                                                .toUpperCase() +
                                                            (snapshot
                                                                .data[index]
                                                                .data["tags"][0]
                                                                .substring(1)),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0,
                                                          fontFamily: 'Raleway'
                                                        ),
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
                      },
                    ));
              }
            }),
      )
    ]);
  }
}
