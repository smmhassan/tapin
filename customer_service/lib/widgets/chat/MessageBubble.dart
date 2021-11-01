import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../../widgets/RoundImage.dart';

const String _keyTableName = 'Message';
const String text = 'message';
const String author = 'user';
const String isCustomer = 'customer';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool customer;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.customer,
  }) : super(key: key);


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
