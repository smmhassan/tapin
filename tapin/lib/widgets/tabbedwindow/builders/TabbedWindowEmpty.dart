import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TabbedWindowEmpty extends StatelessWidget {
  const TabbedWindowEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'could not find anything',
          style: TextStyle(color: Theme.of(context).accentColor),
        ));
  }
}