import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_color/random_color.dart';

import 'inProgDetail.dart';
import 'package:moyawim/homefiles/detailpage.dart';
import 'package:moyawim/pages/drawer.dart';
import 'package:moyawim/homefiles/resultpage.dart';
import '../loader.dart';

class inProgress extends StatefulWidget {
  final String uid;

  inProgress({this.uid});

  @override
  _inProgress createState() => _inProgress();
}

class _inProgress extends State<inProgress> {
  navigateToDetail(DocumentSnapshot ad) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => inProgDetail(
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

  bool showOpt = false;
  bool selected = false;
  List<int> indexList = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: StreamBuilder(
              stream: Firestore.instance.collection("ads").where("poster", isEqualTo: widget.uid).where("phase",isEqualTo:2).snapshots(),
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

                          Color colorCheck() {
                            if (indexList.contains(index)) {
                              return Colors.grey[800];
                            } else {
                              return Colors.white12;
                            }
                          }
                          colorCheck();

                          void selectedCheck(){
                            if(indexList.isEmpty){
                              selected = true;
                            }
                            else{
                              selected = false;
                            }
                          }
                          selectedCheck();

                          void showOptions(){
                            if(!indexList.isEmpty){
                              if(index == 0){
                                showOpt = true;
                              }
                              else{
                                showOpt = false;
                              }
                            }
                            else{
                              showOpt = false;
                            }
                          }
                          showOptions();

                          Future<void> _ackAlert(BuildContext context, var ind) {
                            String dia="Are you sure you want to delete the selected ads?";
                            return showDialog<void>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  elevation: 10.0,
                                  backgroundColor: Colors.grey[900],
                                  title: Text('Delete',
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 26.0,
                                        color: Colors.white
                                    ),
                                  ),
                                  content: Text(
                                    dia,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 16.0,
                                        color: Colors.white
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0
                                          ),
                                        ),
                                        onPressed: () async{
                                          for(int i = 0; i < indexList.length; i++){
                                            await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                              await myTransaction.delete(snapshot.data.documents[i].reference);
                                            });
                                            //await FirebaseStorage.instance.ref().child(snapshot.data.documents[i].documentID).delete();
                                          }
                                          indexList.clear();
                                          Navigator.pop(context);
                                        }
                                    ),
                                    FlatButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          return Container(
                              child: Column(children: <Widget>[
                                Container(
                                  child: showOpt ? Container(
                                    height: 60.0,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              indexList.clear();
                                            });
                                          },
                                          child: Center(
                                            child: Padding(
                                              child: Icon(Icons.close, size: 30.0,),
                                              padding: EdgeInsets.only(right: 10.0),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              for(int i = 0; i < snapshot.data.documents.length; i++){
                                                if(!indexList.contains(i)){
                                                  indexList.add(i);
                                                }
                                              }
                                            });
                                          },
                                          child: Center(
                                            child: Padding(
                                              child: Icon(Icons.apps, size: 30.0,),
                                              padding: EdgeInsets.only(right: 10.0),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              _ackAlert(context, index);
                                            });
                                          },
                                          child: Center(
                                            child: Padding(
                                              child: Icon(Icons.delete, size: 30.0,),
                                              padding: EdgeInsets.only(right: 10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) : null,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCheck();
                                      showOptions();
                                      if (indexList.contains(index)) {
                                        indexList.remove(index);
                                      } else {
                                        if(!selected){
                                          if(indexList.contains(index)){
                                            indexList.remove(index);
                                          }
                                          else{
                                            indexList.add(index);
                                          }
                                        }
                                        else{
                                          navigateToDetail(
                                              snapshot.data.documents[index]);
                                          indexList.clear();
                                        }
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      selectedCheck();
                                      showOptions();
                                      if (indexList.contains(index)) {
                                        indexList.remove(index);
                                      } else {
                                        indexList.add(index);
                                      }
                                    });
                                  },
                                  child: Container(
                                      height: 180.0,
                                      child: Card(
                                          color: colorCheck(),
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
                                                          color:
                                                          Colors.black),
                                                      Text(
                                                        (snapshot
                                                            .data
                                                            .documents[
                                                        index]
                                                            .data[
                                                        "tags"][0]),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontSize: 20.0,
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
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["urls"][0],
                                                      height: 100.0,
                                                      width: 100.0,
                                                      fit: BoxFit.cover,
                                                      filterQuality:
                                                      FilterQuality.low,
                                                      loadingBuilder:
                                                          (BuildContext
                                                      context,
                                                          Widget child,
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
                                            title: snapshot
                                                .data
                                                .documents[index]
                                                .data["title"],
                                            subtitle: snapshot
                                                .data
                                                .documents[index]
                                                .data["description"],
                                            author: snapshot.data.documents[index]
                                                .data["location"],
                                            price: "Price \$" +
                                                snapshot.data.documents[index]
                                                    .data["price"],
                                            ad: snapshot.data.documents[index],
                                          ))),
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
                                "You do not have any Ads in progress yet...",
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
