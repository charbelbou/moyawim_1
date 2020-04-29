import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';

double windowSize = 271;
bool isEditing = false;
class ratingDisplay extends StatelessWidget {
  final String uid;

  ratingDisplay(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.white,
                size: 20,
              ),
              Text(
                (snapshot.data["totalstars"] / snapshot.data["reviewcount"]).toString()=="NaN"?
                "0.0":
                " " +
                    (snapshot.data["totalstars"] / snapshot.data["reviewcount"]).toString().substring(0,3),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Raleway',
                ),
              )
            ],
          );
        });
  }
}

class visitorProfile extends StatefulWidget {
  final String uid;

  visitorProfile(this.uid);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<visitorProfile> {

  Widget getPic(String uid){
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document(widget.uid).snapshots(),
        builder: (context,snapshot){
          String imageUrl=snapshot.data["picture"];
          return CircleAvatar(
            radius: 80,
            backgroundColor: Color(0xFFF1B069),
            child: imageUrl==""?
            Text(
              !snapshot.hasData ? "":snapshot.data['firstname'][0],
              style: TextStyle(fontSize: 40.0),
            ):null,
            backgroundImage: imageUrl!=""?
            NetworkImage(
                snapshot.data["picture"]
            ):null,
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: profHeader(widget.uid)
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                height: 200,
                margin: EdgeInsets.only(bottom: 5.0),
                color: Color(0xFF53CEDB),
                child: Center(
                  child: getPic(widget.uid),
                ),
              ),
              Container(
                child: Card(
                  color: Colors.grey[900],
                  elevation: 5.0,
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(4.0),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: profName(widget.uid),
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Center(
                              child: ratingDisplay(widget.uid),
                            )
                        ),
                        Card(
                          elevation: 10.0,
                          color: Colors.grey[850],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        "About me",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 20.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                profBio(widget.uid),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5.0,
                color: Colors.grey[900],
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 10.0,
                          color: Colors.grey[850],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Contact",
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 20.5
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5.0,),
                                    profEmail(widget.uid),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5.0,),
                              profLoc(widget.uid),
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double findWindowSize() {
  if (!isEditing) {
    windowSize = 372;
    return windowSize;
  } else {
    windowSize = 366;
    return windowSize;
  }
}

class profName extends StatelessWidget {
  final String uid;

  profName(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Text(
              snapshot.data['firstname'] + " " + snapshot.data['lastname'],
              style: TextStyle(fontSize: 24, fontFamily: 'Raleway'));
        });
  }
}
class profHeader extends StatelessWidget {
  final String uid;

  profHeader(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Text(
              snapshot.data['firstname']+"'s profile",
              style: TextStyle(fontFamily: 'Raleway'));
        });
  }
}

class profLoc extends StatelessWidget {
  final String uid;

  profLoc(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Text(snapshot.data['location'],
              style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
        });
  }
}

class profBio extends StatelessWidget {
  final String uid;

  profBio(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Text(snapshot.data['biography'],
              style: TextStyle(fontSize: 16, fontFamily: 'Raleway'));
        });
  }
}

class profEmail extends StatelessWidget {
  final String uid;

  profEmail(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Text(snapshot.data['email'],
              style: TextStyle(fontSize: 18, fontFamily: 'Raleway'));
        });
  }
}
