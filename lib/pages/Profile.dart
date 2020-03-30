import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'drawer.dart';


class Profile extends StatelessWidget {
  final String uid;
  Profile(this.uid);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Account",
            style: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        drawer: drawer(uid,"Profile"),
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  /*decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/Beirut.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),*/
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Center(
                      child: CircleAvatar(
                        radius: 64,
                        //backgroundImage: AssetImage("images/profilepic.jpg"),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Name: Ali Salemeh",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.blue[400],
                        thickness: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: 75,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              Container(
                                width: 32,
                                height: 32,
                                /*child: Image(
                                  image: AssetImage("images/lb.png"),
                                ),*/
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Icon(Icons.location_city),
                              Text(
                                "Beirut",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.blue[400],
                        thickness: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Description:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  width: 450,
                                  height: 100,
                                  child: Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.blue[400],
                        thickness: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: StarRating(
                          size: 25.0,
                          rating: 3.5,
                          color: Colors.orange,
                          borderColor: Colors.orangeAccent,
                        ),
                      ),
                      Divider(
                        color: Colors.blue[400],
                        thickness: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
