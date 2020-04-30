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
          text: 'Moyawim',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 30,
            color: Colors.white,
          ),
      ),
    );
  }
  Widget bulb(){
    return Icon(
        Icons
            .lightbulb_outline,
        color: Colors.white,
      size: 60,
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
            'Don\'t have an account?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color: Colors.white, fontFamily: 'Raleway'),
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
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'),
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
                color: Colors.white,
                thickness: 2,
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(
              color: Colors.white,
                fontFamily: 'Raleway'
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white,
                thickness: 2,
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
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black87,Color(0xFF444152)])),
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      bulb(),
                      SizedBox(height: 0.0),
                      _title(),
                      Form(
                        key:_formkey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 95.0),
                            TextFormField(
                                inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[ ]'))],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Raleway'
                                ),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  labelText: "Email",
                                  prefixIcon:
                                  const Icon(Icons.mail, color: Colors.white),
                                ),
                                validator: (val) => val.isEmpty? 'Enter an email' : null,
                                onChanged: (val){
                                  setState(()=>email=val);
                                }
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                    fontFamily: 'Raleway'
                                ),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  labelText: "Password",
                                  prefixIcon:
                                  const Icon(Icons.lock, color: Colors.white),
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
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)
                                ),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color:Colors.white,fontSize: 15, fontFamily: 'Raleway'),
                                  textAlign: TextAlign.center,
                                ),

                                height:50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),

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