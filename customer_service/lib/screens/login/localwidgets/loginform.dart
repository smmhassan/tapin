import 'package:customer_service/screens/signup/signup.dart';
import 'package:customer_service/screens/userdash/userdash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';

class OurLoginForm extends StatefulWidget {
  @override
  _OurLoginFormState createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController email = TextEditingController();

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  QueryMutation addMutation = QueryMutation();

  bool isChecked = false;

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
              prefixIcon: Icon(Icons.alternate_email,
                  color: const Color.fromARGB(255, 96, 94, 92)),
              hintText: "email",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
            ),
          ),
          TextFormField(
            controller: password,
            obscureText: true,
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline,
                  color: const Color.fromARGB(255, 96, 94, 92)),
              hintText: "password",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
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
                    color: Theme.of(context).accentColor,
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
                    color: Color.fromARGB(255, 255, 251, 245), fontSize: 18),
              ),
            ),
            onPressed: () async {
              GraphQLClient _client = graphQLConfiguration.clientToQuery();
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
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 133, 201, 169),
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
                    color: Color.fromARGB(255, 255, 251, 245), fontSize: 18),
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
              primary: Color.fromARGB(255, 133, 201, 169),
              shape: StadiumBorder(),
            ),
          ),
          TextButton(
              child: Text("forgot password"),
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 96, 94, 92),
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 96, 94, 92),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
