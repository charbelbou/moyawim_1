import 'package:flutter/material.dart';
import 'package:moyawim/loader.dart';
import 'package:moyawim/pages/Register.dart';
import 'package:moyawim/services/auth.dart';
import 'package:moyawim/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';


class Login extends StatefulWidget {

  final Function toggleView;
  Login({this.toggleView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading= false;

  // text field state
  String email='';
  String password='';
  String error="";
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'mo',
          style: GoogleFonts.zillaSlab(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.cyan,
          ),
          children: [
            TextSpan(
              text: 'ya',
              style: TextStyle(color: Colors.cyan, fontSize: 30),
            ),
            TextSpan(
              text: 'wim',
              style: TextStyle(color: Colors.cyan,  fontSize: 30),
            ),
          ]),
    );
  }
  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              widget.toggleView();
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return loading ? ColorLoader(): Scaffold(
        body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _title(),
                      Form(
                        key:_formkey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 130.0),
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                  hintText: "Email",
                                  filled: true,
                                ),
                                validator: (val) => val.isEmpty? 'Enter an email' : null,
                                onChanged: (val){
                                  setState(()=>email=val);
                                }
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                  hintText: "Password",
                                  filled: true,

                                ),
                                validator: (val) => val.length < 6 ? 'Must be more than 6 characters' : null,
                                obscureText: true,
                                onChanged: (val){
                                  setState(()=>password=val);
                                }
                            ),
                            SizedBox(height: 40.0),
                            MaterialButton(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                child: Text(
                                    'Sign in',
                                    style: TextStyle(color:Colors.black,fontSize: 15),

                                    textAlign: TextAlign.center,
                                ),

                                height:50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Colors.blue[300], Colors.teal])),

                              ),
                                onPressed: () async{
                                  if (_formkey.currentState.validate()){
                                    setState(() => loading=true);
                                    dynamic result= await _auth.LoginWithEmailAndPassword(email, password);
                                    if(result == null){
                                      setState(() {
                                        error = "Could not sign in with those credentials";
                                        loading=false;
                                      });
                                    }
                                  }
                                },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _divider(),
                            _createAccountLabel(),


                        ],
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
