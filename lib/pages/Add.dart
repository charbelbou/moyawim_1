import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'Home.dart';
import 'drawer.dart';
import '../loader.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

String dropdownValue = 'Housework';


class Add extends StatelessWidget {
  final String uid;

  Add(this.uid);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              'Post Advertisement',
              style: TextStyle(fontFamily: 'Raleway'),
            ),
          ),
          drawer: drawer(uid, "Add"),
          body: SingleChildScrollView(
            child: Container(

              child: Column(
                children: <Widget>[
                  Body(uid),
                ],
              ),
            ),
          )
    );
  }
}

class category extends StatefulWidget {
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 20,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value;
                });
                },
              items: <String>[
                'Housework',
                'Driving',
                'Education',
                'Technology',
                'Other'
              ].map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
            ),
          ],
        ),
      ),
    );

  }
}



class Body extends StatelessWidget {
  final String uid;

  Body(this.uid);

  TextEditingController titleAdd = TextEditingController();
  TextEditingController descriptionAdd = TextEditingController();
  TextEditingController priceAdd = TextEditingController();
  TextEditingController locationAdd = TextEditingController();
  Date p = Date();
  Image u = Image();
  category cat=category();
  String location="q";
  final db = Firestore.instance;
  @override


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
            'Your ad has been posted!',
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

  titleParser(String title) async {
    List<String> sp = title.split(" ");
    while (sp.contains("")) {
      sp.remove("");
    }
    List<String> ll = [];
    for (int i = 0; i < sp.length; i++) {
      final data = await Firestore.instance
          .collection("dictionary")
          .document(sp[i].toLowerCase())
          .get();
      if (data.exists) {
        //  final pl=data.get().(DocumentSnapshot snap) => snap.data);
        ll = ll + List.from(data["keywords"]);
      }
      ll.add(sp[i].toLowerCase());
    }
    return ll;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.grey[800], Colors.grey[800]])),
            width: 500.0,
            child: new TextField(

                controller: titleAdd,
                keyboardType: TextInputType.multiline,
                maxLines: null,

                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF53CEDB), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)
                      //borderRadius: BorderRadius.all()
                      ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.border_color, color: Color(0xFF53CEDB)),
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF53CEDB), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                style: new TextStyle(
                    fontSize: 15.0, height: 1.2, color: Colors.white))),
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.grey[800], Colors.grey[800]])),
            width: 500.0,
            child: new TextField(
                controller: descriptionAdd,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFFc7B4D), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)
                      //borderRadius: BorderRadius.all()
                      ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.info, color: Color(0xFFFc7B4D)),
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color:  Color(0xFFFc7B4D), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                style: new TextStyle(
                    fontSize: 15.0, height: 1.2, color: Colors.white))),
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.grey[800], Colors.grey[800]])),
            width: 500.0,
            child: new TextField(
                controller: priceAdd,
                keyboardType: TextInputType.number,
                maxLines: null,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFFD7384), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)
                      //borderRadius: BorderRadius.all()
                      ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.attach_money, color: Color(0xFFFD7384)),
                  labelText: 'Price',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFFD7384), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                style: new TextStyle(
                    fontSize: 15.0, height: 1.2, color: Colors.white))),
      ),

      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.grey[800], Colors.grey[800]])),
            width: 500.0,
            child: new TextField(
                controller: locationAdd,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF1B069), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)
                      //borderRadius: BorderRadius.all()
                      ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.add_location, color: Color(0xFFF1B069)),
                  labelText: 'Location',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF1B069), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                style: new TextStyle(
                    fontSize: 15.0, height: 1.2, color: Colors.white))),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: cat,
      ),




      SizedBox(height: 20),
      p,
          u,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(

              child: Text(
                'Post',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Raleway',
                  //fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF2BD093), Color(0xFF2BD093)])),
            ),
            onPressed: () async {
              List<String> pp=await titleParser(dropdownValue+" "+titleAdd.text);
              _ackAlert2(context);
              final docRef= await db.collection('ads').add({
                'title': titleAdd.text,
                'description': descriptionAdd.text,
                'price': priceAdd.text,
                'location': locationAdd.text,
                'poster': uid,
                'worker': "",
                'date':p.createState().getDate(),
                'phase': 1,
              });
              await db.collection('users').document(uid).updateData({
                'ads': FieldValue.arrayUnion([docRef.documentID])
              });


              await db.collection('ads').document(docRef.documentID).updateData({
                'urls': FieldValue.arrayUnion([]),
                'favoritedby': FieldValue.arrayUnion([]),
                'applied': FieldValue.arrayUnion([]),
                'tags':pp.isEmpty ? FieldValue.arrayUnion([]): FieldValue.arrayUnion(pp),
              });
              u.createState().UploadFile(docRef.documentID);
              u.createState().clear();


              _ackAlert(context);
            }),
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
  static List<String> urls= new List<String>();
  int i = 1;
  static List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  void initState() {
    super.initState();
  }

  List<String> geturlList(){
    return urls;
  }

  void clear(){
    images.clear();
    i=1;
  }

  Widget buildGridView() {
    return GridView.count(

      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Container(
          margin: EdgeInsets.only(right: 3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child:AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          )
        ) ;
      }),
    );
  }

  List<Asset> getList() {
    return images;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat", ),
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

  void UploadFile(String adUid) {
    for (var imageFile in images) {
      postImage(imageFile, adUid);
    }
  }

  Future<dynamic> postImage(Asset imageFile,String adUid) async {
    String fileName = i.toString();
    i++;
    StorageReference reference = FirebaseStorage.instance.ref().child(adUid).child(fileName);
    StorageUploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String ref=await reference.getDownloadURL();
    if(uploadTask.isSuccessful){
      Firestore.instance.collection('ads').document(adUid).updateData({
        'urls': FieldValue.arrayUnion([ref])
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 100,
          child: FlatButton(

            color: Colors.transparent,
            child: Icon(
              Icons.image,
              size: 50.0,
              color: Colors.lightBlueAccent,
            ),
            onPressed: loadAssets,
          ),
        ),

        Container(
          height: 190,
          width: 350,
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
