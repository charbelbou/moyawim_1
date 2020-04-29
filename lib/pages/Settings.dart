import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moyawim/services/auth.dart';
import 'Profile Settings.dart';
import 'drawer.dart';


class Settings1 extends StatefulWidget {
  final String uid;

  Settings1(this.uid);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings1> {


  void deleteDocs(String uid)async{
    var p=await Firestore.instance.collection("users").document(uid).get();
    List<String> ads=List.from(p["ads"]);
    for(int i=0;i<ads.length;i++){
      await Firestore.instance.collection("ads").document(ads[i]).delete();
    }
    var app=await Firestore.instance.collection("ads").where("applied",arrayContains: widget.uid).getDocuments();
    var app1=app.documents;
    for(int j=0;j<app1.length;j++){
      await Firestore.instance.collection("ads").document(app1[j].documentID).updateData({
        "applied": FieldValue.arrayRemove([uid]),
      });
    }
  }


  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("Settings", style: TextStyle(fontFamily: 'Raleway')),
        ),
        drawer: drawer(widget.uid, "Settings"),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileSettings(widget.uid,true)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white
                              )
                          )
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: 64,
                            color: Colors.green[500],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                "Profile Settings",
                                style: TextStyle(fontSize: 16, fontFamily: 'Raleway'),
                              ),
                              subtitle: Text(
                                "Edit what other users see on your profile page",
                                style: TextStyle(fontSize: 16, fontFamily: 'Raleway'),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      String dia="Are you sure you want to deactivate your account?";
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 10.0,
                            backgroundColor: Colors.grey[900],
                            title: Text('Deactivate account',
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
                                    Navigator.pop(context);
                                    deleteDocs(widget.uid);
                                  //  await Firestore.instance.collection("users").document(widget.uid).delete();
                                    FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                    Navigator.pop(context);
                                    await user.delete();
                                    await _auth.signOut();
                                    Navigator.pop(context);
                                    print("aq");
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
                    },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white
                            )
                        )
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,
                          size: 64,
                          color: Colors.redAccent,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              "Deactivate Account",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                  color: Colors.red),
                            ),
                            subtitle: Text(
                              "Remove your account from Moyawim's Database",
                              style: TextStyle(fontSize: 16, fontFamily: 'Raleway'),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
