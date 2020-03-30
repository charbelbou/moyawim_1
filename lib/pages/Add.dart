import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'Home.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class Add extends StatelessWidget {
  final String uid;
  Add(this.uid);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Moyawim',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Post Advertisement',
                style: TextStyle(fontFamily: 'Raleway'),
              ),
            ),
            drawer: drawer(uid,"Add"),
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black12, Colors.white10])),
                child: Column(
                  children: <Widget>[
                    Body(uid),
                  ],
                ),
              ),
            )
      ),
    );
  }
}
class Body extends StatelessWidget{
  final String uid;
  Body(this.uid);
  TextEditingController titleAdd = TextEditingController();
  TextEditingController descriptionAdd = TextEditingController();
  TextEditingController priceAdd = TextEditingController();
  TextEditingController locationAdd = TextEditingController();
  Date p=Date();
  Image u=Image();
  final db = Firestore.instance;
  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: const Text('Your ad has been posted!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home(uid))
                );
              }
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
       child: Column(children: <Widget>[
              u,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 500.0,
                    child: new TextField(
                        controller: titleAdd,
                        decoration: new InputDecoration(
                          prefixIcon: const Icon(Icons.border_color,
                              color: Colors.white),
                          hintText: 'Title',
                        //  border: OutlineInputBorder(),
                        ),
                        style: new TextStyle(
                            fontSize: 15.0, height: 1.2, color: Colors.white))),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 500.0,
                    child: new TextField(
                        controller: descriptionAdd,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: new InputDecoration(
                          prefixIcon:
                          const Icon(Icons.info, color: Colors.white),
                          hintText: 'Description',
                    //      border: OutlineInputBorder(),
                        ),
                        style: new TextStyle(
                            fontSize: 15.0, height: 1.2, color: Colors.white))),
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: 400.0,
                    child: new TextField(
                        controller: priceAdd,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          prefixIcon: const Icon(Icons.attach_money,
                              color: Colors.white),
                          hintText: 'Price',
                 //         border: OutlineInputBorder(),
                        ),
                        style: new TextStyle(
                            fontSize: 15.0, height: 1.2, color: Colors.white))),
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 500.0,
                    child: new TextField(
                        controller: locationAdd,
                        decoration: new InputDecoration(
                          prefixIcon: const Icon(Icons.add_location,
                              color: Colors.white),
                          hintText: 'Location',
                 //         border: OutlineInputBorder(),
                        ),
                        style: new TextStyle(
                            fontSize: 15.0, height: 1.2, color: Colors.white))),
              ),
              SizedBox(height: 20),

              p,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      child: Text(
                        'Post',
                        style: TextStyle(color:Colors.black,fontSize: 15),

                        textAlign: TextAlign.center,
                      ),

                      height:50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),

                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.white,Colors.white70]
                          )
                      ),

                    ),
                  onPressed: () async{
                       final docRef= await db.collection('ads').add({
                      'title': titleAdd.text,
                      'description': descriptionAdd.text,
                      'price': priceAdd.text,
                      'location': locationAdd.text,
                      'poster': uid,
                      'date':p.createState().getDate(),
                      'completion ': false,
                       'tags':FieldValue.arrayUnion(["test"]),
                    });
                       await db.collection('users').document(uid).updateData({
                         'ads': FieldValue.arrayUnion([docRef.documentID])
                       });

                       _ackAlert(context);
                  }
                ),
              ),
         SizedBox(height: 20),

       ]));
  }
}
class Image extends StatefulWidget {
  @override
  _ImageState createState() => _ImageState();
}

class _ImageState extends State<Image> {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://moyawim-67b6b.appspot.com/');
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  void initState() {
    super.initState();
  }
  void UploadFile(Asset pic){
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats');
    //StorageUploadTask uploadTask = storageReference.(pic);
  }


  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
  List<Asset> getList(){
    return images;
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pick Images",
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
      _error = error;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          color:Colors.white,
          child: Icon(Icons.image,color: Colors.black,),
          onPressed: loadAssets,
        ),

        Container(
          height:190,
          width:350,
          child: buildGridView(),
        ),
      ],
    );
  }
}

class Date extends StatefulWidget {

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  static DateTime selectedDate = DateTime.now();

      Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  DateTime getDate() {
    return selectedDate;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                borderSide: BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onPressed: () => _selectDate(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Done on",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                color: Colors.transparent,
              ),
              SizedBox(
                height: 20.0,
              ),
            ]),
      ),
    );
  }
}



