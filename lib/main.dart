import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:moyawim/pages/Add.dart';
import 'package:moyawim/pages/Profile.dart';
import 'package:moyawim/pages/Login.dart';
import 'package:moyawim/pages/Wrapper.dart';
import 'package:moyawim/pages/Home.dart';
import 'package:moyawim/pages/test.dart';
import 'package:moyawim/pages/Wrapper.dart';
import 'package:moyawim/services/auth.dart';
import 'package:provider/provider.dart';
import 'user.dart';

import 'pages/globals.dart' as globals;
import 'package:flutter/services.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      )
    );
  }
}


