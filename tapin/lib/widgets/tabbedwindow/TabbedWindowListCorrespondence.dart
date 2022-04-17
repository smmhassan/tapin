import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class TabbedWindowListCorrespondence extends StatelessWidget {
  /*
  list tile with logo/image, name and
  further description
   */
  final ImageProvider image;
  final String name;
  final String description;
  final bool dense;

  const TabbedWindowListCorrespondence({
    Key? key,
    required this.image,
    required this.name,
    required this.description,
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
      subtitle: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme.of(context).selectedRowColor,
        ),
      ),
      trailing: OutlinedButton(
        child: Text('prioritize'),
        style: OutlinedButton.styleFrom(
            primary: Theme.of(context).buttonColor,
            side: BorderSide(
              color: Theme.of(context).buttonColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 5,
              bottom: 6,
            ),
            minimumSize: Size(0,0)
        ),
        onPressed: () {
        },
      ),
      //isThreeLine: true,
    );
  }
}