import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class CorrespondenceListTile extends StatelessWidget {
  /*
  list tile with logo/image and name
   */
  final ImageProvider image;
  final String name;
  final String description;
  final double width;

  const CorrespondenceListTile({
    Key? key,
    required this.image,
    required this.name,
    required this.description,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        bottom: 0,
        right: 10,
        left: 10,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: 80,
                  maxHeight: 80,
                  minWidth: 55,
                  minHeight: 55,
                ),
                child: RoundImage(
                  image: image,
                  size: width*.13,
                  borderSize: 0,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).selectedRowColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            child: Icon(
              Icons.more_vert,
              size: 30,
              color: Theme.of(context).selectedRowColor,
            ),
          ),
        ],
      ),
    );
  }
}