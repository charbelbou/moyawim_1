import 'package:flutter/material.dart';
import 'package:moyawim/pages/FirstPage.dart';
import 'package:moyawim/pages/Register.dart';

import 'Home.dart';
import 'Login.dart';
import 'Authenticate.dart';
import 'package:moyawim/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);

    //return either home or authenticate
    if(user!=null){
      return Home(user.uid);
    }
    else{
      return Authenticate();
    }
  }
}
