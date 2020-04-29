import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection("users");

  Future updateUserData(String firstName,String lastName,String email) async{
    return await userCollection.document(uid).setData({
      'firstname':firstName,
      'lastname':lastName,
      'email':email,
      'reviewcount':0,
      'totalstars':0,
      'location':"",
      'picture':"",
      'phone':"",
      'new': true
    });
  }
}


