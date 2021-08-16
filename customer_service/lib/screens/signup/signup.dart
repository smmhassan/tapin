import 'package:customer_service/screens/signup/localwidgets/signUpForm.dart';
import 'package:flutter/material.dart';

class OurSignup extends StatelessWidget {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(),
                  ],
                ),
                SizedBox(height: 40.0,),
                OurSignUpForm(),
              ],
            ), //ListView
          )
        ],
      ),
    );
  }
}
