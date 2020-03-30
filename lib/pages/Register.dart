import 'package:flutter/material.dart';
import 'package:moyawim/services/auth.dart';
import 'package:moyawim/loader.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading= false;
  Widget _title() {
    return RichText(
      text: TextSpan(
          text: 'Register',
          style: GoogleFonts.zillaSlab(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.cyan,
            ),
          ),
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
            'Have an account?',
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
              'Login',
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


  String email = "";
  String firstname = "";
  String lastname = "";
  String location = "";
  String password= "";
  String error="";
  @override
  Widget build(BuildContext context) {
    return loading ? ColorLoader(): Scaffold(
      body: SingleChildScrollView(
        child: Container(
     //       height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
//                  padding: EdgeInsets.fromLTRB(10, 10, 50, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      _title(),
                      Form(
                          key:_formkey,
                          child: Column(
                              children: <Widget>[
                                SizedBox(height: 30.0),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:TextFormField(
                                  decoration: InputDecoration(
                                        contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                        hintText: "First name",
                                        filled: true,
                                      ),
                                      validator: (val) => val.isEmpty ? 'Enter a first name' : null,
                                      onChanged: (val){
                                        setState(()=>firstname=val);
                                      }
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                        hintText: "Last name",
                                        filled: true,

                                      ),
                                      validator: (val) => val.isEmpty? 'Enter a last name' : null,
                                      onChanged: (val){
                                        setState(()=>lastname=val);
                                      }
                                  ),
                                ),

                                SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                        hintText: "Email",
                                        filled: true,

                                      ),
                                      validator: (val) => val.isEmpty? 'Enter an email' : null,
                                      onChanged: (val){
                                        setState(()=>email=val);
                                      }
                                  ),
                                ),

                                SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                        hintText: "Password",
                                        filled: true,

                                      ),
                                      validator: (val) => val.length < 6 ? 'Must be more than 6 characters' : null,
                                      obscureText: true,
                                      onChanged: (val){
                                        setState(()=>password=val);
                                      }
                                  ),
                                ),
                                SizedBox(height: 40.0),
                            ],
                          ),
                        ),
                      MaterialButton(
                        child: Container(
                          child: Text(
                            'Register',
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
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password,firstname,lastname);
                            if(result == null){
                              setState(() {
                                error = "Please supply valid email";
                                loading=false;
                              });
                            }
                          }
                        },
                      ),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
