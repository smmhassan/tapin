import 'package:tapin/screens/login/localwidgets/loginform.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OurLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(25.0),
              children: <Widget>[
                SizedBox(
                  height: 90.0,
                ),
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Image.asset("assets/logo3.png"),
                ),
                SizedBox(
                  height: 1.0,
                ),
                OurLoginForm(),
              ],
            ), //ListView
          )
        ],
      ),
    );
  }
}
