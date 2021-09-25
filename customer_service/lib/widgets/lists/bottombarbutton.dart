import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBarButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  final double iconSize = 25;
  final double fontSize = 15;

  const BottomBarButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          //height: AppBar().preferredSize.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  icon,
                  color: Theme.of(context).canvasColor,
                  size: iconSize,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}