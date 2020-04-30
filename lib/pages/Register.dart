import 'package:flutter/material.dart';
import 'package:moyawim/services/auth.dart';
import 'package:moyawim/loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

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
          style: GoogleFonts.raleway(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.white70,

            ),
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
  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Have an account?',
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
              'Login',
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


  String email = "";
  String firstname = "";
  String lastname = "";
  String location = "";
  String password= "";
  String error="";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return loading ? ColorLoader(): Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87,Color(0xFF444152)])),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      _title(),
                      Form(
                          key:_formkey,
                          child: Column(
                              children: <Widget>[
                                SizedBox(height: 30.0),
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
                                        labelText: "First name",
                                    prefixIcon: const Icon(Icons.account_circle, color: Colors.white),

                                  ),
                                      validator: (val) => val.isEmpty ? 'Enter a first name' : null,
                                      onChanged: (val){
                                        setState(()=>firstname=val);
                                      }
                                ),
                                SizedBox(height: 40.0),

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
                                      labelText: "Last name",
                                      prefixIcon: const Icon(Icons.account_circle, color: Colors.white),

                                    ),
                                    validator: (val) => val.isEmpty? 'Enter a last name' : null,
                                    onChanged: (val){
                                      setState(()=>lastname=val);
                                    }
                                ),


                                SizedBox(height: 40.0),
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
                                      prefixIcon: const Icon(Icons.mail, color: Colors.white),

                                    ),

                                    validator: (val) => val.isEmpty? 'Enter an email' : null,
                                    onChanged: (val){
                                      setState(()=>email=val);
                                    }
                                ),


                                SizedBox(height: 40.0),

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
                                      prefixIcon: const Icon(Icons.lock, color: Colors.white),

                                    ),
                                    validator: (val) => val.length < 6 ? 'Must be more than 6 characters' : null,
                                    obscureText: true,
                                    onChanged: (val){
                                      setState(()=>password=val);
                                    }
                                ),
                                SizedBox(height: 40.0),
                            ],
                          ),
                        ),
                      MaterialButton(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)
                          ),
                          child: Text(
                            'REGISTER',
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
                      _divider(),
                      _createAccountLabel(),
                      SizedBox(height: 68.0),
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
