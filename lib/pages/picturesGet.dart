import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../loader.dart';

class getPic extends StatefulWidget {
  String uid;
  DocumentSnapshot ad;

  getPic({this.ad});

  @override
  _getPicState createState() => _getPicState();
}

class _getPicState extends State<getPic> {
  bool isImage = false;


  @override
  Widget build(BuildContext context) {
    void check(){
      var len1 = widget.ad.data["urls"];
      int len;
      if(len1 != null){
        int len = widget.ad.data["urls"].length;
        if(len != 0){
          isImage = true;
        }
        else{
          isImage = false;
        }
      }
    }
    check();

    return Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          itemCount: widget.ad.data["urls"].length,
                itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.only(right: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.white, )
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          widget.ad.data["urls"][index],
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: ColorLoader(),
                            );
                          },
                        )),
                  );                    
                },
              ));
  }
}
