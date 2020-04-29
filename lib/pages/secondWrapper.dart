import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Profile Settings.dart';
import 'Home.dart';


class secondWrapper extends StatelessWidget {
  final String uid;
  secondWrapper(this.uid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(uid).snapshots(),
      builder: (context,snapshot){
        bool temp= (!snapshot.hasData || snapshot.hasError)  ? false :snapshot.data["new"];
        if(temp==true){
          return ProfileSettings(uid,false);
        }
        else{
          return Home(uid);
        }
      }

    );
  }
}

