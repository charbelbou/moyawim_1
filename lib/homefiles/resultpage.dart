import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:random_color/random_color.dart';

import 'detailpage.dart';
import '../loader.dart';
import '../pages/applicants.dart';

class ResultPage extends StatefulWidget {
  final String st;
  final String uid;

  ResultPage({this.st, this.uid});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  navigateToDetail(DocumentSnapshot ad, String uid) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(ad: ad, uid: uid)));
  }

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  bool _isMyAdd1 = false;
  bool isImage = false;
  bool isEmpty = false;

  List<String> tagParser(String tags){
    List<String> sp = tags.split(" ");
    while (sp.contains("")) {
      sp.remove("");
    }
    return sp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Results for " + "'" + widget.st + "'",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        backgroundColor: Colors.black,
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("ads")
                .where("tags", arrayContainsAny: tagParser(widget.st)).where("phase",isEqualTo: 1).snapshots(),
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
                      void check() {
                        if (snapshot.data.documents[index].data["poster"] == widget.uid) {
                          _isMyAdd1 = true;
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
                        onTap: () =>
                            navigateToDetail(snapshot.data.documents[index], widget.uid),
                        child: Container(
                            height: 180.0,
                            child: Card(
                                color: Colors.white12,
                                child: CustomListItemTwo(
                                  thumbnail: Container(
                                      margin: EdgeInsets.all(3.0),
                                      height: 100.0,
                                      width: 100.0,
                                      child: !isImage ? Card(
                                        color: _color(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.lightbulb_outline,
                                                color: Colors.black),
                                            Text(
                                              (snapshot.data.documents[index].data["tags"]
                                                  [0]),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
                                                  fontFamily: 'Raleway'),
                                            )
                                          ],
                                        ),
                                      ) :
                                      ClipRRect(
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
                                          ))
                                  ),
                                  title: snapshot.data.documents[index].data["title"],
                                  subtitle:
                                      snapshot.data.documents[index].data["description"],
                                  author: snapshot.data.documents[index].data["location"],
                                  //publishDate: 'Dec 28',
                                  readDuration: Container(),
                                  price: "Price \$" +
                                      snapshot.data.documents[index].data["price"],
                                  uid: widget.uid,
                                  ad: snapshot.data.documents[index],
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
                            child: Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 100.0,),
                          ),
                          Center(
                            child: Text(
                              "Sorry, no Ads have been found...",
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

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription(
      {Key key,
      this.title,
      this.subtitle,
      this.author,
      this.publishDate,
      this.readDuration,
      this.price,
      this.uid,
      this.ad})
      : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final Container readDuration;
  final String price;
  final String uid;
  final DocumentSnapshot ad;

  @override
  Widget build(BuildContext context) {
    navigateToApplicants(DocumentSnapshot ad) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Applicants(ad: ad)));
    }

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
                        fontFamily: 'Raleway'),
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
                    fontSize: 15.0, color: Colors.white, fontFamily: 'Raleway'),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      '$price',
                      style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () => navigateToApplicants(ad),
                      child: readDuration,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo(
      {Key key,
      this.thumbnail,
      this.title,
      this.subtitle,
      this.author,
      this.publishDate,
      this.readDuration,
      this.price,
      this.uid,
      this.ad})
      : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final Container readDuration;
  final String price;
  final String uid;
  final DocumentSnapshot ad;

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
                  uid: uid,
                  ad: ad,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
