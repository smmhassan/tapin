import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final double cornerRadius = 25;
  final double topPadding = 80;
  final double sidePadding = 20;
  final double dividerThickness = 0.5;


  final List<String> items;

  const NavigationDrawer({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
          left: Radius.circular(cornerRadius)
      ),
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
          ),
          child: ListView.separated(
            padding: EdgeInsets.only(
              top: topPadding,
              right: sidePadding,
              left: sidePadding,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  items[index],
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                thickness: dividerThickness,
                color: Theme.of(context).canvasColor,
              );
            },
          ),
        ),
      ),
    );
  }
}