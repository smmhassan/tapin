import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbedWindowLoading extends StatelessWidget {
  const TabbedWindowLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'loading...',
          style: TextStyle(color: Theme.of(context).accentColor),
        ));
  }
}