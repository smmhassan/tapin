import 'package:flutter/material.dart';
import 'package:tapin/widgets/tabbedwindow/UserSettingsTabbed.dart';

void main() => runApp(MaterialApp(
  home:ProfileApp(),
));

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.pinkAccent, Colors.lightGreenAccent]
                  )
              ),
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage('assets/beesechurger.jpg'),
                        radius: 50.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Ben Bartholomew",
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(

                                  children: <Widget>[
                                    Text(
                                      "Communities",
                                      style: TextStyle(
                                        color: Colors.purpleAccent[100],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "10",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.purpleAccent[100],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(

                                  children: <Widget>[
                                    Text(
                                      "Friends",
                                      style: TextStyle(
                                        color: Colors.purpleAccent[100],
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "42",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.purpleAccent[100],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(

                                  children: <Widget>[
                                    Text(
                                      "Beesechurger",
                                      style: TextStyle(
                                        color: Colors.purpleAccent[100],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "1300",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.purpleAccent[100],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Bio:",
                    style: TextStyle(
                        color: Colors.purpleAccent[100],
                        fontStyle: FontStyle.normal,
                        fontSize: 28.0
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('filler filler filler.\n'
                      'temp temp temp.',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: 300.00,

            child: RaisedButton(
                onPressed: (){

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserSettings())
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)
                ),
                elevation: 0.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.lightGreenAccent,Colors.pinkAccent]
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text("Settings",
                      style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}