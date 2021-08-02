import 'package:flutter/material.dart';

class OurLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          ),
          TextFormField(decoration: InputDecoration(prefixIcon: Icon(Icons.alternate_email), hintText: "email"),
          ),
          TextFormField(decoration: InputDecoration(prefixIcon: Icon(Icons.lock_outline), hintText: "password"),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text("login", style: TextStyle(color: Colors.black),),
            ),
            onPressed: (){},
          )
        ],
      ),
    );
  }
}
