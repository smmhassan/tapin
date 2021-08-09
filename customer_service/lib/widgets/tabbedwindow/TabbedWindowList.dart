import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbedWindowList extends StatelessWidget {
  /*
  styled list view for tabbed windows
   */
  final double padding = 10;
  final double dividerPadding = 15;

  final List<Widget> listItems;

  const TabbedWindowList({
    Key? key,
    required this.listItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: padding/3,
        bottom: padding,
      ),
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
            stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.separated(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            final item = listItems[index];
            return item;
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
              indent: dividerPadding,
              endIndent: dividerPadding,
            );
          },
        ),
      ),
    );
  }
}