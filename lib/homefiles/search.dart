import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math';

import 'resultpage.dart';
import '../loader.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CreateSearchView extends StatefulWidget {
  @override
  _CreateSearchViewState createState() => _CreateSearchViewState();
}

class _CreateSearchViewState extends State<CreateSearchView> {
  navigateToSearchPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.0, top: 25.0),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: Colors.black12),
      child: TextField(
        enableInteractiveSelection: false,
        focusNode: new AlwaysDisabledFocusNode(),
        onTap: () {
          navigateToSearchPage();
        },
        decoration: InputDecoration(
            hintText: "Search for Ads",
            hintStyle: new TextStyle(
                color: Colors.grey[450], decoration: TextDecoration.none),
            border: InputBorder.none),
        style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchTag = "";
  TextEditingController _val = TextEditingController();

  navigateToResult(String st) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResultPage(st: st)));
  }

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

  List colors = [
    Color(0xFFFD7384),
    Color(0xFF2BD093),
    Color(0xFFFc7B4D),
    Color(0xFF53CEDB),
    Color(0xFFF1B069),
    Color(0xFFFc7B9B),
    Color(0xFFF2A758),
  ];

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  static final _random = Random();

  static int min = 1, max = 4;

  int next(int min, int max) => min + _random.nextInt(max - min);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                searchTag = _val.text.toLowerCase();
                navigateToResult(searchTag);
              },
            )
          ],
          backgroundColor: Colors.transparent,
          title: TextField(
            decoration: InputDecoration(
                hintText: "Search for Ads",
                hintStyle: new TextStyle(
                    color: Colors.grey[350], decoration: TextDecoration.none, fontFamily: 'Raleway'),
                border: InputBorder.none),
            style:
                TextStyle(color: Colors.white, decoration: TextDecoration.none),
            textAlign: TextAlign.center,
            controller: _val,
            onSubmitted: (_val) {
              searchTag = _val.toLowerCase();
              navigateToResult(searchTag);
            },
          ),
        ),
        body: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ColorLoader(),
              );
            }
            else{
            return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black12, Colors.white10])),
                child: Column(children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            "Suggested tags",
                            style: TextStyle(fontSize: 25.0, fontFamily: 'Raleway'),
                          ))
                    ],
                  )),
                  Expanded(
                      flex: 9,
                      child:ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            GestureDetector(
                                onTap: () => navigateToResult(
                                    snapshot.data[index].data["tags"][0]),
                                child: Container(
                                    margin: EdgeInsets.all(7.0),
                                    height: 90.0,
                                    width: 120.0,
                                    child: Card(
                                      color: _color(),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.lightbulb_outline,
                                              color: Colors.black),
                                          Text(
                                            (snapshot.data[index].data["tags"]
                                                [0]),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontFamily: 'Raleway'),
                                          )
                                        ],
                                      ),
                                    ))),
                            GestureDetector(
                                onTap: () => navigateToResult(snapshot
                                    .data[(index + 1) * next(min, max)]
                                    .data["tags"][0]),
                                child: Container(
                                    margin: EdgeInsets.all(7.0),
                                    height: 90.0,
                                    width: 120.0,
                                    child: Card(
                                      color: _color(),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.lightbulb_outline,
                                              color: Colors.black),
                                          Text(
                                            (snapshot
                                                .data[(index + 1) *
                                                    next(min, max)]
                                                .data["tags"][0]),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontFamily: 'Raleway'),
                                          )
                                        ],
                                      ),
                                    ))),
                            GestureDetector(
                                onTap: () => navigateToResult(snapshot
                                    .data[(index + 2) * next(min, max)]
                                    .data["tags"][0]),
                                child: Container(
                                    margin: EdgeInsets.all(7.0),
                                    height: 90.0,
                                    width: 120.0,
                                    child: Card(
                                      color: _color(),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.lightbulb_outline,
                                              color: Colors.black),
                                          Text(
                                            (snapshot
                                                .data[(index + 2) *
                                                    next(min, max)]
                                                .data["tags"][0]),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontFamily: 'Raleway'),
                                          )
                                        ],
                                      ),
                                    ))),
                          ]));
                    },
                  ))
                ]));}
          },
        ));
  }
}
