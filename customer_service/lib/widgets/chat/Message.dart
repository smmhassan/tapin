import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class Message extends StatelessWidget {
  /*
  list tile with logo/image and name
   */
  final String author;
  final String text;
  final bool customer;

  const Message({
    Key? key,
    required this.author,
    required this.text,
    required this.customer,
  }) : super(key: key);

  @override
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