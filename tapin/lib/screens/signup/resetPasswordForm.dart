import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapin/services/graphQLConf.dart';
import "package:tapin/services/queryMutation.dart";
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  QueryMutation addMutation = QueryMutation();
  TextEditingController email = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  void initState() {
    email = TextEditingController();
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
            controller: email,
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined,
                  color: const Color.fromARGB(255, 96, 94, 92)),
              hintText: "please enter your email",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12.5),
                child: Text(
                  "reset password",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 251, 245), fontSize: 18),
                ),
              ),
              onPressed: () async {
                final ParseUser user = ParseUser(null, null, email.text.trim());
                final ParseResponse parseResponse =
                    await user.requestPasswordReset();
                if (parseResponse.success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Reset link sent! Check your email')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Invalid email, please try again')));
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
