import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class OrganizationListTile extends StatelessWidget {
  /*
  list tile with logo/image and name
   */
  final ImageProvider image;
  final String name;

  const OrganizationListTile({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          RoundImage(
            image: image,
            size: 35,
            borderSize: 0,
            color: Colors.white,
          ),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).accentColor,
            ),
          ),
          Icon(
            Icons.more_vert,
          ),
        ],
      ),
    );
  }
}