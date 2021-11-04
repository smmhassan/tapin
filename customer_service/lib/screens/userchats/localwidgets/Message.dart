import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

const String _keyTableName = 'Message';
const String text = 'message';
const String author = 'user';
const String fromID = 'idFrom';

class Message extends ParseObject implements ParseCloneable {
  Message() : super(_keyTableName);
  Message.clone() : this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  clone(Map<String, dynamic> map) => Message.clone()..fromJson(map);

  String? get message => get<String>(text);
  set message(String? message) => set<String>(text, message!);

  ParseUser? get user => get<ParseUser>(author);
  set user(ParseUser? user) => set<ParseUser>(author, user!);

  String? get idFrom => get<String>(fromID);
  set idFrom(String? idFrom) => set<String>(fromID, idFrom!);

  bool toAndFromCheck(String idFrom) {
    bool temp = false;
    if (user!.objectId.toString() == idFrom) temp = true;
    return temp;
  }

  Widget build(BuildContext context) {
    return Container(
      alignment:
          toAndFromCheck(idFrom!) ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          color: toAndFromCheck(idFrom!)
              ? Theme.of(context).buttonColor
              : Theme.of(context).accentColor,
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
