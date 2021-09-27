import 'package:http_parser/http_parser.dart' as http_parser;
import 'dart:io';
import 'package:customer_service/api/GoogleSignInAPI.dart';
import 'package:customer_service/screens/userdash/userdash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class OurSignUpForm extends StatefulWidget {
  @override
  _OurSignUpFormState createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController email = TextEditingController();

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  QueryMutation addMutation = QueryMutation();

  @override
  void initState() {
    username = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    super.initState();
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
                controller: username,
                style: TextStyle(fontSize: 18.0),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline,
                      color: const Color.fromARGB(255, 96, 94, 92)),
                  hintText: "username",
                  hintStyle: TextStyle(
                      fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
                ),
              ),
              TextFormField(
                controller: email,
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
              TextFormField(
                obscureText: true,
                style: TextStyle(fontSize: 18.0),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_open,
                      color: const Color.fromARGB(255, 96, 94, 92)),
                  hintText: "confirm password",
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
                      "signup",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 251, 245), fontSize: 18),
                    ),
                  ),
                  onPressed: () async {
                    ParseFileBase? parseFile2;
                    parseFile2 = ParseFile(File("path"));
                    GraphQLClient _client = graphQLConfiguration.clientToQuery();
                    QueryResult result = await _client.mutate(
                      MutationOptions(
                        document: gql(
                         addMutation.signUp(
                            username.text,
                            password.text,
                            email.text,
                            "undefined",
                             //parseFile2,
                          ),
                        ),
                      ),
                    );
                    print (result.exception);
                    if (!result.hasException) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 133, 201, 169),
                    shape: StadiumBorder(),
                  )),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                      ),
                      label: Text( 'Sign Up with Google'),
                      onPressed: signIn,
                  ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              )
            ],
      ),
    );
  }

  Future signIn() async {
    final newUser = await GoogleSignInAPI.login();
    if(newUser == null){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up Failed')));
    }
    else {
      //final picture = Image.network(newUser.photoUrl.toString());
      String filePath = newUser.photoUrl.toString();
      //ParseFileBase? parseFile;

      //final file = http.MultipartFile.fromPath('displayPicture', filePath);

      //parseFile = ParseFile(File(filePath));
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(
            addMutation.signUp(
              newUser.displayName.toString(),
              "Fall2021",
              newUser.email.toString(),
              newUser.id.toString(),
              //parseFile,
            ),
          ),
        ),
      );
      print (result.exception);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up Succeeded!')));
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => UserDash(),
      ));*/
    }
  }
}
