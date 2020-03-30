import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_color/random_color.dart';
import 'package:moyawim/homefiles/detailpage.dart';
import 'package:moyawim/pages/drawer.dart';
import 'package:moyawim/homefiles/resultpage.dart';
import '../loader.dart';

class myAds extends StatefulWidget {
  final String uid;
  myAds({this.uid});
  @override
  _myAdsState createState() => _myAdsState();
}

class _myAdsState extends State<myAds> {
  Future _data;

  Future getAds() async {
    var fs = Firestore.instance;

    QuerySnapshot qn = await fs
        .collection("ads")
        .where("tags")
        .getDocuments();

    return qn.documents;
  }

  Future getPersonalAds() async {
    var fs = Firestore.instance.collection("users").document(widget.uid);

    return fs.snapshots();
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
    return Scaffold(
        appBar: AppBar(
          title: Text("My Ads",
            style: TextStyle(fontFamily: 'Raleway'),),
        ),
        drawer: drawer(widget.uid,"myAds"),

        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ColorLoader(),
                );
              } else {
                return Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Column(children: <Widget>[
                              GestureDetector(
                                onTap: () =>
                                    navigateToDetail(snapshot.data[index]),
                                child: Container(
                                    height: 180.0,
                                    child: Card(
                                        color: Colors.white12,
                                        child: CustomListItemTwo(
                                            thumbnail: Container(
                                                margin: EdgeInsets.all(3.0),
                                                height: 100.0,
                                                width: 100.0,
                                                child: Card(
                                                  color: _color(),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons
                                                          .lightbulb_outline,
                                                          color: Colors.black),
                                                      Text(
                                                        (snapshot.data[index]
                                                            .data["tags"][0]),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily: 'Raleway'),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            title: snapshot.data[index]
                                                .data["title"],
                                            subtitle: snapshot
                                                .data[index]
                                                .data["description"],
                                            author:
                                            snapshot.data[index]
                                                .data["location"],
                                            //publishDate: 'Dec 28',
                                            //readDuration: '100 views',
                                            price: "Price \$" +
                                                snapshot.data[index]
                                                    .data["price"]))),
                              ),
                            ]));
                      },
                    ));
              }
            }));
  }
}

