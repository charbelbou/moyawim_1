import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_color/random_color.dart';
import 'package:moyawim/homefiles/detailpage.dart';
import 'package:moyawim/pages/drawer.dart';
import 'package:moyawim/homefiles/resultpage.dart';
import '../loader.dart';

class Favorites extends StatefulWidget {
  final String uid;
  Favorites({this.uid});
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Future _data;

  Future getAds() async {
    var fs = Firestore.instance;

    QuerySnapshot qn = await fs
        .collection("ads")
        .where("favoritedby", arrayContains: widget.uid)
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
        context, MaterialPageRoute(builder: (context) => DetailPage(ad: ad,uid:widget.uid)));
  }

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favorites",
            style: TextStyle(fontFamily: 'Raleway'),),
        ),
        drawer: drawer(widget.uid,"favorites"),

        backgroundColor: Colors.black,
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("ads")
                .where("favoritedby", arrayContains: widget.uid)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ColorLoader(),
                );
              } else {

                void checkEmpty (){
                  if(snapshot.data.documents.length == 0){
                    isEmpty = true;
                  }
                }

                checkEmpty();

                return !isEmpty ? Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Column(children: <Widget>[
                              GestureDetector(
                                onTap: () =>
                                    navigateToDetail(snapshot.data.documents[index]),
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
                                                        (snapshot.data.documents[index]
                                                            .data["tags"][0]),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily: 'Raleway'),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            title: snapshot.data.documents[index]
                                                .data["title"],
                                            subtitle: snapshot
                                                .data.documents[index]
                                                .data["description"],
                                            author:
                                            snapshot.data.documents[index]
                                                .data["location"],
                                            //publishDate: 'Dec 28',
                                            //readDuration: '100 views',
                                            price: "Price \$" +
                                                snapshot.data.documents[index]
                                                    .data["price"],
                                            readDuration: Container(),
                                        ))),
                              ),
                            ]));
                      },
                    )) :
                Container(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Icon(Icons.favorite_border, color: Colors.grey, size: 100.0,),
                          ),
                          Center(
                            child: Text(
                              "You have not favorited any Ads yet...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 30.0,
                                  color: Colors.grey
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}

