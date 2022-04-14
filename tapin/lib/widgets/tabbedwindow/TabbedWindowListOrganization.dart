import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class TabbedWindowListOrganization extends StatelessWidget {
  /*
  list tile with logo/image and name
   */
  final ImageProvider image;
  final String name;
  final bool dense;

  const TabbedWindowListOrganization({
    Key? key,
    required this.image,
    required this.name,
    required this.dense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: dense,
      leading: RoundImage(
        image: image,
        size: 35,
        borderSize: 0,
        color: Colors.white,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme.of(context).accentColor,
        ),
      ),
      trailing: Icon(Icons.more_vert),
    );
  }
}