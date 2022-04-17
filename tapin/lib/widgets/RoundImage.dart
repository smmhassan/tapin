import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  /*
  takes an image, its size, border size and
  border color and returns an appropriate
  rounded image
   */
  final ImageProvider image;
  final double size;
  final double borderSize;
  final Color color;

  const RoundImage({
    Key? key,
    required this.image,
    required this.size,
    required this.borderSize,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container (
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: borderSize,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: image,
            fit: BoxFit.fill
        ),
      ),
    );
  }
}