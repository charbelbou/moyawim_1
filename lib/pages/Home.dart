import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moyawim/homefiles/content.dart';
import 'drawer.dart';
import 'package:moyawim/homefiles/latestads.dart';



class Home extends StatelessWidget {
  final String uid;
  Home(this.uid);
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Moyawim",
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Moyawim",
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          drawer: drawer(uid,"Home"),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black12, Colors.white10])),
              child: Column(
                children: <Widget>[
                  Content(),
                  ListPage(),
                  SizedBox(
                    height: 400.0,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
