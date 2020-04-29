import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moyawim/homefiles/content.dart';
import 'drawer.dart';
import 'package:moyawim/homefiles/latestads.dart';
import 'recommenedAds.dart';



class Home extends StatelessWidget {
  final String uid;
  Home(this.uid);
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: AppBar(
            title: Text(
              "Moyawim",
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            backgroundColor: Colors.grey[900],
            elevation: 0.0,
          ),
          drawer: drawer(uid,"Home"),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.black45,
              child: Column(
                children: <Widget>[
                  Content(uid),
                  recommendedAds(uid),
                  ListPage(uid),
                  SizedBox(
                    height: 15.0,
                  )
                ],
              ),
            ),
          ),
    );
  }
}
