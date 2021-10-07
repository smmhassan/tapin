import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class SetPassword extends StatefulWidget {
  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  QueryMutation addMutation = QueryMutation();

  ParseUser? user = ParseUser('', '', '');

  TextEditingController password = TextEditingController();

  TextEditingController confirmpassword = TextEditingController();

  @override
  void initState() {
    initData().then((bool success) {
      ParseUser.currentUser().then((currentUser) {
        setState(() {
          user = currentUser;
        });
      });
    }).catchError((dynamic _) {});
    password = TextEditingController();
    confirmpassword = TextEditingController();
    super.initState();
  }

  Future<bool> initData() async {
    /*await Parse().initialize(
      keyParseApplicationId,
      keyParseServerUrl,
      clientKey: keyParseClientKey,
      debug: keyDebug,
    );*/

    return (await Parse().healthCheck()).success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 8.0),
          ),
          TextFormField(
            controller: password,
            obscureText: true,
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline,
                  color: const Color.fromARGB(255, 96, 94, 92)),
              hintText: "please set a password: ",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
            ),
          ),
          TextFormField(
            controller: confirmpassword,
            obscureText: true,
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline,
                  color: const Color.fromARGB(255, 96, 94, 92)),
              hintText: "please confirm password: ",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
            ),
          ),
          ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12.5),
                child: Text(
                  "set account password",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 251, 245), fontSize: 18),
                ),
              ),
              onPressed: () {
                user = ParseUser("Mujtaba Hassan", "Fall2021", '');
                if (password.text == confirmpassword.text) {
                  user!.set("password", password.text);
                  user!.save();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Password set successfully! You may now sign in. Do not forget to confirm your email!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Passwords do not match, please try again')));
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 133, 201, 169),
                shape: StadiumBorder(),
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          )
        ],
      ),
    );
  }
}
