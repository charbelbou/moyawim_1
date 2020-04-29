import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'Settings.dart';
import '../loader.dart';

class ProfileSettings extends StatefulWidget {
  final String uid;
  final bool wpage;

  ProfileSettings(this.uid,this.wpage);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  static List<Asset> images = List<Asset>();
  String dloc;

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10.0,
          backgroundColor: Colors.grey[900],
          title: Text(
            'Success',
            style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0),
          ),
          content: const Text(
            'Your Profile has been modified',
            style: TextStyle(
                fontFamily: 'Raleway', fontSize: 16.0, color: Colors.white),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                onPressed: () {
                 // Navigator.push(context,
               //       MaterialPageRoute(builder: (context) => Settings1(widget.uid)));
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Future<void> _ackAlert2(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 10.0,
            backgroundColor: Colors.grey[900],
            content: ColorLoader())
        ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> loadAssets() async {
      images.clear();
      List<Asset> resultList = List<Asset>();
      String error = 'No Error Dectected';
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat",
          ),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Pick Profile Picture",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
      }

      if (!mounted) return;

      setState(() {
        images = resultList;
      });
    }

    return StreamBuilder(
      stream: Firestore.instance
          .collection("users")
          .document(widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        TextEditingController firstName = TextEditingController(
            text: !snapshot.hasData ? "Loading" : snapshot.data["firstname"]);
        TextEditingController lastName = TextEditingController(
            text: !snapshot.hasData ? "Loading" : snapshot.data["lastname"]);
        TextEditingController bio = TextEditingController(
            text: !snapshot.hasData ? "Loading" : snapshot.data["biography"]);
        TextEditingController location = TextEditingController(
            text: !snapshot.hasData ? "Loading" : snapshot.data["location"]);
        TextEditingController phoneNumber = TextEditingController(
            text: !snapshot.hasData ? "Loading" : snapshot.data["phone"]);
        String imageUrl = !snapshot.hasData ? "" : snapshot.data["picture"];

        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            title: Text(
              "Edit Profile",
              style: TextStyle(fontFamily: 'Raleway'),
            ),
          ),
          body: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      itemExtent: 120,
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            height: 100,
                            width: 100,
                            child: GestureDetector(
                                onTap: loadAssets,
                                child: Center(
                                  child: images.isEmpty
                                      ? CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Color(0xFFF1B069),
                                          child: imageUrl == ""
                                              ? Text(
                                                  !snapshot.hasData
                                                      ? ""
                                                      : snapshot
                                                          .data['firstname'][0],
                                                  style:
                                                      TextStyle(fontSize: 40.0),
                                                )
                                              : null,
                                          backgroundImage: imageUrl != ""
                                              ? NetworkImage(
                                                  snapshot.data["picture"],
                                                )
                                              : null,
                                        )
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Color(0xFFF1B069),
                                          backgroundImage:
                                              AssetThumbImageProvider(
                                            images[0],
                                            height: 200,
                                            width: 200,
                                            quality: 100,
                                          )),
                                )),
                          ),
                          TextField(
                              controller: firstName,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF53CEDB), width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0)
                                    //borderRadius: BorderRadius.all()
                                    ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF53CEDB), width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              style: new TextStyle(
                                  fontSize: 15.0,
                                  height: 1.2,
                                  color: Colors.white)), //First Name
                          TextField(
                              controller: lastName,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFF1B069), width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0)
                                    //borderRadius: BorderRadius.all()
                                    ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFF1B069), width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              style: new TextStyle(
                                  fontSize: 15.0,
                                  height: 1.2,
                                  color: Colors.white)), //Last Name
                          TextField(
                            controller: bio,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: new TextStyle(
                                fontSize: 15.0,
                                height: 1.2,
                                color: Colors.white),
                            decoration: new InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFFc7B4D), width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              labelText: 'Biography',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFFc7B4D), width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ), //Bio
                          TextField(
                            controller: phoneNumber,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              maskTextInputFormatter,
                            ],
                            style: new TextStyle(
                                fontSize: 15.0,
                                height: 1.2,
                                color: Colors.white),
                            decoration: new InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFFc7B4D), width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              labelText: 'Phone number',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFFc7B4D), width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ), //B
                          TextField(
                              controller: location,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFFD7384), width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                labelText: 'Location',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFFD7384), width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              style: new TextStyle(
                                  fontSize: 15.0,
                                  height: 1.2,
                                  color: Colors.white)),
                          IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 52,
                            ),
                            onPressed: () async {
                              if(widget.wpage==true){
                                _ackAlert2(context);
                              }
                              await Firestore.instance
                                  .collection("users")
                                  .document(widget.uid)
                                  .updateData({
                                'firstname': firstName.text,
                                'lastname': lastName.text,
                                'biography': bio.text,
                                'location': location.text,
                                'phone': phoneNumber.text,
                                'new': false
                              });
                              if(images.isNotEmpty){
                                StorageReference reference = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child("user_" + widget.uid)
                                    .child("1");
                                StorageUploadTask uploadTask = reference.putData(
                                    (await images[0].getByteData())
                                        .buffer
                                        .asUint8List());
                                StorageTaskSnapshot storageTaskSnapshot =
                                await uploadTask.onComplete;
                                String ref = await reference.getDownloadURL();
                                if (uploadTask.isSuccessful) {
                                  print(ref);
                                  Firestore.instance
                                      .collection('users')
                                      .document(widget.uid)
                                      .updateData({'picture': ref});
                                }
                              }
                              if(widget.wpage==true){
                                _ackAlert(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
