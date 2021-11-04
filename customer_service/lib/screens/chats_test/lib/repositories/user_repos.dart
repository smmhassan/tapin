
import 'package:meta/meta.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class BaseUserRepository {
  Future<ParseUser> authenticate({@required String username, @required String email, @required String password,});
  Future<ParseUser> signup({@required String username, @required String email, @required String password, });
  Future<ParseUser> currentUser();
  Future<bool> logout();
}

class UserRepository extends BaseUserRepository {
  
  UserRepository();

  /// Auth [email], [password]
  /// 
  /// Return [ParseUser]
  Future<ParseUser> authenticate({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    var user = ParseUser(username, password, email);
    var response = await user.login();
    if (response.success)
      return response.result;
    return null;
  }

  /// Signup [username], [email], [password]
  /// 
  /// Return [ParseUser]
  Future<ParseUser> signup({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    var user = ParseUser(username, password, email);
    var result = await user.save();
    if (result.success) {
      return user;
    }
    return null;
  }

  /// Select current [ParseUser].
  ///
  Future<ParseUser> currentUser() async {
    return await ParseUser.currentUser();
  }

  Future<bool> logout() async {
    ParseUser user = await ParseUser.currentUser();
    var result = await user.logout();
    return result.success;
  }

}
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../../widgets/RoundImage.dart';
const String keyTableName = 'Message';
class Message extends ParseObject implements ParseCloneable {
  /*
  list tile with logo/image and name
   */
  final String author;
  final String text;
  final String isCustomer;

  Message({
    required this.author,
    required this.text,
    required this.isCustomer
  }) : super(keyTableName);
  Message.clone() : this();

  String? get message => get<String>(text);
  set message(String? message) => set<String>(text, message!);

  ParseUser? get user => get<ParseUser>(author);
  set user(ParseUser? user) => set<ParseUser>(author, user!);

  bool? get customer => get<bool>(isCustomer);
  set customer(bool? customer) => set<bool>(isCustomer, customer!);

  clone(Map<String, dynamic> map) => Message.clone()..fromJson(map);
  Widget build(BuildContext context) {
    return Container(
      alignment: customer? Alignment.topRight: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          color: customer? Theme.of(context).buttonColor: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}