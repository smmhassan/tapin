import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class TabbedWindowListFAQ extends StatelessWidget {
  /*
  list tile with a question, short answer,
  and button to see full answer
   */
  final String question;
  final String answer;
  final bool dense;

  const TabbedWindowListFAQ({
    Key? key,
    required this.question,
    required this.answer,
    required this.dense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: dense,
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme.of(context).accentColor,
        ),
      ),
      subtitle: Text(
        answer,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme.of(context).selectedRowColor,
        ),
      ),
      trailing: TextButton(
        onPressed: () {
        },
        child: Text(
          'see more',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      //isThreeLine: true,
    );
  }
}