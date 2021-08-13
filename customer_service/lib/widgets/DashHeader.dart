import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundImage.dart';

class DashHeader extends StatelessWidget {
  final double height;
  final Widget leftItem;
  final ImageProvider image;
  final String label;

  const DashHeader({
    Key? key,
    required this.height,
    required this.leftItem,
    required this.image,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSize = height*.85;
    double padding = height*.15;
    double imageBorderSize = 3;
    return Container(
      padding: EdgeInsets.only(
        top: padding,
        right: padding,
        left: padding,
        bottom: 0,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leftItem,
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(width: 10),
                RoundImage(
                  image: image,
                  size: imageSize,
                  borderSize: imageBorderSize,
                  color: Theme.of(context).buttonColor,
                ),
              ],
            )
          ]
      ),
    );
  }
}