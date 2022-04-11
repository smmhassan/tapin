import 'package:customer_service/screens/signup/signup.dart';
import 'package:customer_service/screens/userdash/userdash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OurLoginForm extends StatefulWidget {
  @override
  _OurLoginFormState createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  QueryMutation addMutation = QueryMutation();
  TextEditingController email = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  bool isChecked = false;
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          ),
          TextFormField(
            controller: username,
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined,
                  color: const Color.fromARGB(255, 255, 246, 20)),
              hintText: "email",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 255, 246, 20)),
            ),
          ),
          TextFormField(
            controller: password,
            obscureText: true,
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline,
                  color: const Color.fromARGB(255, 255, 246, 20)),
              hintText: "password",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 255, 246, 20)),
            ),
          ),
          /*RadioListTile(
            value: 1,
            title: const Text('remember me'),
            groupValue: 1,
            onChanged: (value) {
            // setState(() { });
            },
            toggleable: true,
            controlAffinity: ListTileControlAffinity.platform,
          ),*/
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Checkbox(
                    checkColor: Colors.white,
                    value: isChecked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ),
                Text(
                  'remember me',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ElevatedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12.5),
              child: Text(
                "login",
                style: TextStyle(
                    color: Theme.of(context).canvasColor, fontSize: 18),
              ),
            ),
            onPressed: () async {
              /*GraphQLClient _client = graphQLConfiguration.clientToQuery();
              QueryResult result = await _client.mutate(
                MutationOptions(
                  document: gql(
                    addMutation.signIn(
                      username.text,
                      password.text,
                      //email.text.trim(),
                    ),
                  ),
                ),
              );
              print(result.data);
              if (!result.hasException) {
                Navigator.pushNamed(context, '/userdash');
              }*/
              ParseUser user = ParseUser(username.text, password.text, '');
              ParseResponse response = await user.login();

              username.clear();
              password.clear();
              if (user.emailVerified == false) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Please verify your email before signing in')));
              }

              if (response.success) {
                Navigator.pushNamed(context, '/userdash');
              } else {
                if (response.error?.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.error!.message)));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              shape: StadiumBorder(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          ),
          ElevatedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 90, vertical: 12.5),
              child: Text(
                "register",
                style: TextStyle(
                    color: Theme.of(context).canvasColor, fontSize: 18),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurSignup(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              shape: StadiumBorder(),
            ),
          ),
          TextButton(
              child: Text("forgot password"),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/resetpasswordscreen');
              })
        ],
      ),
    );
  }
}
