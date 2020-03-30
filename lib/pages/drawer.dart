import 'package:flutter/material.dart';
import 'package:moyawim/pages/myAds.dart';
import 'package:moyawim/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Add.dart';
import 'Home.dart';
import 'Profile.dart';

class fName extends StatelessWidget {
  final String uid;
  fName(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Text("Loading");
          return Text(snapshot.data['firstname']+" "+snapshot.data['lastname'],style: TextStyle(fontFamily: 'Raleway'));
        }
    );
  }
}
class email extends StatelessWidget {
  final String uid;
  email(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Text("Loading");
          return Text(snapshot.data['email'],style: TextStyle(fontFamily: 'Raleway'));
        }
    );
  }
}
class firstl extends StatelessWidget {
  final String uid;
  firstl(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Text("Loading");
          return CircleAvatar(
            child: Text(
              snapshot.data['firstname'][0],
              style: TextStyle(fontSize: 40.0),
            ),
          );
        }
    );
  }
}

class drawer extends StatelessWidget {
  final String uid;
  final String temp;
  drawer(this.uid,this.temp);

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: fName(uid),
            accountEmail: email(uid),
            currentAccountPicture: firstl(uid),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => temp=="Home" ? Profile(uid) : Home(uid)));
            },
            leading: Icon(temp=="Home" ? Icons.account_circle : Icons.home),
            title: Text(temp=="Home" ? "My Account" : "Home",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => temp=="Add" ? Profile(uid): Add(uid)));
            },
            leading: Icon(temp=="Add" ? Icons.account_circle : Icons.add_circle),
            title: Text(temp=="Add" ? "My Account" : "Post Advertisement" ,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => temp=="myAds" ? Profile(uid): myAds(uid:uid)));
            },
            leading: Icon(temp=="myAds" ? Icons.account_circle : Icons.work),
            title: Text(
              temp=="myAds" ? "My Account" : "Jobs",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text(
              "Bookmarks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 175,
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(
              "Help",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              await _auth.signOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Log Out",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
