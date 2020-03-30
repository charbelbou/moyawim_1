import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math';

import 'detailpage.dart';
import '../loader.dart';

class ResultPage extends StatefulWidget {
  final String st;

  ResultPage({this.st});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future _data;

  Future getAds() async {
    var fs = Firestore.instance;

    QuerySnapshot qn = await fs
        .collection("ads")
        .where("tags", arrayContains: widget.st)
        .getDocuments();

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Results for " + "'" + widget.st + "'", style: TextStyle(fontFamily: 'Raleway'),),
        ),
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
                        onTap: () => navigateToDetail(snapshot.data[index]),
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
                                              Icon(Icons.lightbulb_outline,
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
                                    title: snapshot.data[index].data["title"],
                                    subtitle: snapshot
                                        .data[index].data["description"],
                                    author:
                                        snapshot.data[index].data["location"],
                                    //publishDate: 'Dec 28',
                                    //readDuration: '100 views',
                                    price: "Price \$" +
                                        snapshot.data[index].data["price"]))),
                      ),
                    ]));
                  },
                ));
              }
            }));
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
    this.price,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Raleway'),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0, top: 8.0)),
              Container(
                  padding: EdgeInsets.only(right: 7.0),
                  child: Text(
                    '$subtitle',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                        fontFamily: 'Raleway'
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                    fontFamily: 'Raleway'
                ),
              ),
              Text(
                '$price',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                    fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
    this.price,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  readDuration: readDuration,
                  price: price,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
