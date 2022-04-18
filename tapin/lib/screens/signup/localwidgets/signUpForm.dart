import 'package:tapin/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tapin/screens/userchats/localwidgets/Message.dart';
import 'package:tapin/services/graphQLConf.dart';
import "package:tapin/services/queryMutation.dart";

class OurSignUpForm extends StatefulWidget {
  @override
  _OurSignUpFormState createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  QueryMutation addMutation = QueryMutation();
  TextEditingController email = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController displayName = TextEditingController();
  bool flag = false;
  bool isEnabled = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    displayName = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    super.initState();
    bool flag = false;
    bool isEnabled = false;

    // displayName.addListener(() {
    //   setState(() {
    //     isEnabled = displayName.text.isNotEmpty;
    //   });
    // });

    // email.addListener(() {
    //   setState(() {
    //     isEnabled = email.text.isNotEmpty;
    //   });
    // });

    // password.addListener(() {
    //   setState(() {
    //     isEnabled = password.text.isNotEmpty;
    //   });
    // });

    // confirmPassword.addListener(() {
    //   setState(() {
    //     isEnabled = confirmPassword.text.isNotEmpty;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 8.0),
          ),
          TextFormField(
            controller: displayName,
            onChanged: (text) {
              setState(() {});
              validateButton();
            },
            style: TextStyle(fontSize: 18.0),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person,
                  color: const Color.fromARGB(255, 96, 94, 92)),
              hintText: "display name",
              hintStyle: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 148, 144, 141)),
            ),
          ),
          TextFormField(
            controller: email,
            onChanged: (text) {
              setState(() {});
              validateButton();
            },
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
            onChanged: (text) {
              setState(() {});
              validateButton();
            },
            obscureText: true,
            style: TextStyle(fontSize: 18.0),
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     setState(() {
            //       isEnabled = false;
            //     });
            //     print(isEnabled);
            //   } else {
            //     setState(() {
            //       isEnabled = false;
            //     });
            //     print(isEnabled);
            //   }
            // },
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
            controller: confirmPassword,
            onChanged: (text) {
              setState(() {});
              validateButton();
            },
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
              onPressed: isEnabled
                  ? () async {
                      _signup();
                    }
                  : null,
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

  void validateButton() {
    if (password.text == '' ||
        confirmPassword.text == '' ||
        displayName.text == '' ||
        email.text == '') {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
    // if (displayName.text == '')
    //   isEnabled = false;
    // else
    //   isEnabled = true;
  }

  void _signup() async {
    //ParseFileBase? parseFile2;
    /* var multipartFile2 = http.MultipartFile.fromBytes(
                          'file',
                          (await rootBundle.load(
                              '')).buffer.asUint8List(),
                          contentType: http_parser.MediaType('image', 'jpg')
                      ); */
    //parseFile2 = ParseFile(File("path"));
    bool emailvalid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email.text);
    if (password.text == '' ||
        confirmPassword.text == '' ||
        displayName.text == '' ||
        email.text == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something is empty')));
    } else if (!emailvalid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a valid email')));
    } else if (password.text == confirmPassword.text) {
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(
            addMutation.signUp(
              email.text,
              password.text,
              email.text,
              displayName.text,
            ),
          ),
        ),
      );
      print(result.exception);
      if (!result.hasException) {
        Navigator.of(context).pop();
      } else {
        //go back to login
        if (!flag) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OurLogin(),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match, please try again')));
    }
  }
}
