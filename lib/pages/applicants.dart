import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';


import '../loader.dart';
import 'package:moyawim/homefiles/resultpage.dart';

class Applicants extends StatefulWidget {
  DocumentSnapshot ad;

  Applicants({this.ad});

  @override
  _ApplicantsState createState() => _ApplicantsState();
}

class _ApplicantsState extends State<Applicants> {
  Future _data;

  Future getAds() async {
    var fs = Firestore.instance;
    QuerySnapshot qn = await fs.collection("users").getDocuments();
    return qn.documents;
  }
  Future<void> _ackAlert(BuildContext context,String name) {
    String dia="You have hired "+name+" for this job!";
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(dia),
          actions: <Widget>[
            FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
            ),
          ],
        );
      },
    );
  }

  List<String> getApplied() {
    List<String> applied = List.from(widget.ad.data["applied"]);
    return applied;
  }

  List<DocumentSnapshot> applicants = [];
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    _data = getAds();
  }

  static RandomColor _randomColor = RandomColor();

  Color _color() =>
      _randomColor.randomColor(colorBrightness: ColorBrightness.light);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: Firestore.instance.collection("users").snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ColorLoader(),
              );
            } else {
              void getApplicantsId() {
                if(getApplied().length != 0){
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  for (int j = 0; j < getApplied().length; j++) {
                    if (snapshot.data.documents[i].documentID == getApplied()[j]) {
                      applicants.add(snapshot.data.documents[i]);
                    }
                  }
                }
              }}
              getApplicantsId();

              void checkEmpty(){
                if(getApplied().length == 0){
                  isEmpty = true;
                }
              }
              checkEmpty();

              var len = getApplied().length;
              return !isEmpty ? Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: applicants.length,
                    itemBuilder: (context, index){
                      return Container(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                height: 180.0,
                                child: Card(
                                  color: Colors.white12,
                                  child: CustomListItemTwo(
                                    thumbnail: Container(
                                      margin: EdgeInsets.all(3.0),
                                      height: 100.0,
                                      width: 100.0,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFFF1B069),
                                        child: applicants[index].data["picture"] == ""
                                            ? Text(
                                          applicants[index].data['firstname'][0],
                                          style: TextStyle(fontSize: 40.0),
                                        )
                                            : null,
                                        backgroundImage: applicants[index].data["picture"] != ""
                                            ? NetworkImage(applicants[index].data["picture"])
                                            : null,
                                      ),
                                      ),

                                    title: applicants[index].data["firstname"] + " " + applicants[index].data["lastname"],
                                    subtitle: applicants[index].data["biography"],
                                    author: (applicants[index].data["totalstars"]/applicants[index].data["reviewcount"]).toString()=="NaN"?
                                    "0.0":
                                    " " +
                                        (applicants[index].data["totalstars"]/applicants[index].data["reviewcount"]).toString().substring(0,3),
                                    price: applicants[index].data["location"],
                                    readDuration: Container(),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width : MediaQuery.of(context).size.width,
                              child: FlatButton.icon(
                                icon: Icon(Icons.check,color: Colors.green,size: 25),
                                label:Text(
                                  "Hire",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                onPressed: ()async{
                                  final docRef= await Firestore.instance.collection('ads').document(widget.ad.documentID).updateData({
                                    'worker': applicants[index].documentID,
                                    'phase': 2
                                  });
                                  _ackAlert(context, applicants[index].data["firstname"] + " " + applicants[index].data["lastname"]);

                                },
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white,width: 1),
                                  borderRadius:BorderRadius.all(Radius.circular(10)),
                                  color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ) : Container(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(Icons.sentiment_dissatisfied, color: Colors.grey, size: 100.0,),
                        ),
                        Center(
                          child: Text(
                            "Sorry, there are no applicants...",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 30.0,
                                color: Colors.grey
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
