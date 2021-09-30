import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TabbedWindowList.dart';

class TabbedWindow extends StatelessWidget {
  /*
  takes a title, list of tab names, and
  a list of lists for the tabs and returns
  a titles window with tabs for
  each list provided
   */
  final double padding = 7;
  final double cornerRadius = 8;
  final double maxTabHeight = 40;
  final double minTabHeight = 30;
  final double buttonHeight = 28;
  final double buttonWidth = 150;
  final double buttonOffset = 11;

  final String title;
  final List<String> tabNames;
  final List<Widget> lists;
  final double height;
  final double titleSize;
  final String viewAllRoute;

  const TabbedWindow({
    Key? key,
    required this.title,
    required this.tabNames,
    required this.lists,
    required this.height,
    required this.titleSize,
    required this.viewAllRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double availableHeight = height-titleSize-2*padding-2*buttonOffset;
    double tabHeight = availableHeight*.17;
    double listHeight = availableHeight*.83;

    if (tabHeight > maxTabHeight) {
      tabHeight = maxTabHeight;
      listHeight = availableHeight - tabHeight;
    }

    return Expanded(
      child: Column(
        children: [
          // title
          Container(
            padding: EdgeInsets.only(left: padding),
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: titleSize,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // window
          Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: [
                // main window
                Container(
                  margin: EdgeInsets.only(
                    left: padding,
                    right: padding,
                    top: padding,
                    bottom: padding+buttonOffset,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Theme.of(context).disabledColor,
                  ),
                  child: DefaultTabController(
                      length: tabNames.length,
                      child: Column(
                          children: [
                            // tabs
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: maxTabHeight,
                                minHeight: minTabHeight,
                              ),
                              height: tabHeight,
                              child: TabBar(
                                labelColor: Theme.of(context).accentColor,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(cornerRadius),
                                        topRight: Radius.circular(cornerRadius)
                                    ),
                                    color: Theme.of(context).cardColor
                                ),
                                tabs: [
                                  for(var title in tabNames) Tab(text: title),
                                ],
                              ),
                            ),
                            // lists
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(cornerRadius),
                                  bottomRight: Radius.circular(cornerRadius),
                                ),
                                color: Theme.of(context).cardColor,
                              ),
                              height: listHeight,
                              child: TabBarView(
                                children: [
                                  for(var list in lists) list,
                                ],
                              ),
                            ),
                          ]
                      )
                  ),
                ),
                // button
                Positioned(
                  bottom: padding+buttonOffset-buttonHeight/2,
                  //top: padding+height-buttonHeight/2,
                  height: buttonHeight,
                  width: buttonWidth,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, viewAllRoute);
                      },
                      child: const Text('view all'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).buttonColor
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(buttonHeight/2),
                              )
                          )
                      )
                  ),
                )
              ]
          ),
        ],
      ),
    );
  }
}