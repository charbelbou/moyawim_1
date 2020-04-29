import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moyawim/pages/myAds.dart';
import 'package:moyawim/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Add.dart';
import 'Home.dart';
import 'Profile.dart';
import 'favorites.dart';
import 'myAppAds.dart';
import 'jobs.dart';
import 'myAds2.dart';
import 'Settings.dart';

class fName extends StatelessWidget {
  final String uid;

  fName(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Text(
              snapshot.data['firstname'] + " " + snapshot.data['lastname'],
              style: TextStyle(fontFamily: 'Raleway', color: Colors.black));
        });
  }
}

class email extends StatelessWidget {
  final String uid;

  email(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.black,
                size: 17,
              ),
              Text(
              (snapshot.data["totalstars"] / snapshot.data["reviewcount"]).toString()=="NaN"?
                  "0.0":
                " " +
                    (snapshot.data["totalstars"] / snapshot.data["reviewcount"]).toString().substring(0,3),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Raleway',
                ),
              )
            ],
          );
        });
  }
}

class firstl extends StatelessWidget {
  final String uid;

  firstl(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading");
          return CircleAvatar(
            backgroundColor: Color(0xFFF1B069),
            child: snapshot.data["picture"] == ""
                ? Text(
                    snapshot.data['firstname'][0],
                    style: TextStyle(fontSize: 40.0),
                  )
                : null,
            backgroundImage: snapshot.data["picture"] != ""
                ? NetworkImage(snapshot.data["picture"])
                : null,
          );
        });
  }
}

class drawer extends StatelessWidget {
  final String uid;
  final String temp;

  drawer(this.uid, this.temp);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Drawer(
      child: SingleChildScrollView(
        child: Container(
            height: height * 1.02,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: fName(uid),
                  accountEmail: email(uid),
                  currentAccountPicture: firstl(uid),
                  decoration: BoxDecoration(color: Color(0xFF53CEDB)),
                ),
                Expanded(
                    flex: 6,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: height*0.063,
                            color: temp == "Home"
                                ? Colors.grey[900]
                                : Colors.black,
                            margin: EdgeInsets.only(
                              bottom: 7.0,
                            ),
                            child: ListTile(
                              onTap: () {
                                if(temp != "Home"){
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home(uid)));
                                }
                                else{
                                  Navigator.of(context).pop();
                                }

                              },
                              leading: Icon(
                                Icons.home,
                                color: Color(0xFFFc7B4D),
                              ),
                              title: Text(
                                "Home",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Raleway'),
                              ),
                            ),
                          ), //Home
                          Container(
                            height: height*0.063,

                            color: temp == "Profile"
                                ? Colors.grey[900]
                                : Colors.black,
                            margin: EdgeInsets.only(
                              bottom: 7.0,
                            ),
                            child: ListTile(
                              onTap: () {
                                if(temp != "Profile"){
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile(uid)));
                                }
                                else{
                                  Navigator.of(context).pop();
                                }
                              },
                              leading: Icon(
                                Icons.person,
                                color: Colors.green,
                              ),
                              title: Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Raleway'),
                              ),
                            ),
                          ), //Profile
                          Container(
                            height: height*0.063,

                            color:
                                temp == "Add" ? Colors.grey[900] : Colors.black,
                            margin: EdgeInsets.only(
                              bottom: 7.0,
                            ),
                            child: ListTile(
                              onTap: () {
                                if(temp != "Add"){
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Add(uid)));
                                }
                                else{
                                  Navigator.of(context).pop();
                                }
                              },
                              leading: Icon(
                                Icons.add_circle,
                                color: Color(0xFF2BD093),
                              ),
                              title: Text(
                                "Post Advertisement",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Raleway'),
                              ),
                            ),
                          ), //Post Ad
                          Container(
                            height: height*0.063,

                            color: temp == "myAds"
                                ? Colors.grey[900]
                                : Colors.black,
                            margin: EdgeInsets.only(
                              bottom: 7.0,
                            ),
                            child: ListTile(
                              onTap: () {
                                if(temp != "myAds"){
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              myAds2(uid: uid)));
                                }
                                else{
                                  Navigator.of(context).pop();
                                }
                              },
                              leading: Icon(
                                Icons.bookmark,
                                color: Colors.lightBlueAccent,
                              ),
                              title: Text(
                                "My Ads",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Raleway'),
                              ),
                            ),
                          ), //My Ads
                          Container(
                            height: height*0.063,

                            color: temp == "myJobs"
                                ? Colors.grey[900]
                                : Colors.black,
                            margin: EdgeInsets.only(
                              bottom: 7.0,
                            ),
                            child: ListTile(
                              onTap: () {
                                if(temp != "myJobs"){
                                Navigator.of(context).pop();
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              myJobs(uid: uid)));
                                }
                                else{
                                  Navigator.of(context).pop();
                                }
                              },
                              leading: Icon(
                                Icons.work,
                                color: Color(0xFFF1B069),
                              ),
                              title: Text(
                                "Applied Ads",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Raleway'),
                              ),
                            ),
                          ), //Applied Ads
                          Container(
                            height: height*0.063,

                            color: temp == "favorites"
                                ? Colors.grey[900]
                                : Colors.black,
                            margin: EdgeInsets.only(
                              bottom: 7.0,
                            ),
                            child: ListTile(
                              onTap: () {
                                if(temp != "favorites"){
                                Navigator.of(context).pop();
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Favorites(uid: uid)));
                                }
                                else{
                                  Navigator.of(context).pop();
                                }
                              },
                              leading: Icon(
                                Icons.favorite,
                                color: Color(0xFFFD7384),
                              ),
                              title: Text(
                                "Favorites",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Raleway'),
                              ),
                            ),
                          ), //Favorites
                        ],
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                        height: height*0.063,

                        color: temp == "Settings"
                            ? Colors.grey[900]
                            : Colors.black,
                        margin: EdgeInsets.only(
                          bottom: 7.0,
                        ),
                        child: ListTile(
                          onTap: () {
                            if(temp != "Settings"){
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Settings1(uid)));
                            }
                            else{
                              Navigator.of(context).pop();
                            }
                          },
                          leading: Icon(
                            Icons.settings,
                            color: Colors.grey,
                          ),
                          title: Text(
                            "Settings",
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'Raleway'),
                          ),
                        ),
                      ),


                      Container(
                        height: height*0.063,

                        color: Colors.black,
                        margin: EdgeInsets.only(
                          bottom: 7.0,
                        ),
                        child: ListTile(
                          onTap: () async {
                            await _auth.signOut();
                          },
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Log Out",
                            style:
                            TextStyle(fontSize: 18, fontFamily: 'Raleway'),
                          ),
                        ),
                      ),
                    ],
                  )),
                ), //Help, Log Out
              ],
            )),
      ),
    );
  }
}
