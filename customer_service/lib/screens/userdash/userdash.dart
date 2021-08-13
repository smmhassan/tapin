import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/tabbedwindow/TabbedWindow.dart';
import '../../widgets/tabbedwindow/TabbedWindowList.dart';
import '../../widgets/tabbedwindow/TabbedWindowListOrganization.dart';
import '../../widgets/tabbedwindow/TabbedWindowListCorrespondence.dart';
import '../../widgets/DashHeader.dart';
import '../../widgets/NavigationDrawer.dart';

class UserDash extends StatelessWidget {
  final double headerHeight = .12;
  final double listHeight = .36;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
      ),
      endDrawer: NavigationDrawer(
        items: [
          'Dashboard',
          'Organizations',
          'Correspondences',
          'Settings',
          'Logout'
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // rewards and user info
              DashHeader(
                height: constraints.maxHeight*headerHeight,
                leftItem: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: constraints.maxHeight*headerHeight*.55,
                        color: Theme.of(context).accentColor,
                      ),
                      Text(
                        '100',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ]
                ),
                image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                label: 'Place Holder',
              ),
              // organizations window
              TabbedWindow(
                height: constraints.maxHeight*listHeight,
                title: 'Organizations',
                tabNames: [
                  'favorites',
                  'popular',
                  'new',
                ],
                lists: [
                  TabbedWindowList(
                    listItems: [
                      TabbedWindowListOrganization(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'owl',
                      ),
                      TabbedWindowListOrganization(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'big owl',
                      ),
                      TabbedWindowListOrganization(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'smol owl',
                      ),
                      TabbedWindowListOrganization(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'cool owl',
                      ),
                    ],
                  ),
                  TabbedWindowList(
                    listItems: [
                      TabbedWindowListOrganization(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'popular owl',
                      ),
                    ],
                  ),
                  TabbedWindowList(
                    listItems: [
                      TabbedWindowListOrganization(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'new owl',
                      ),
                    ],
                  ),
                ],
              ),
              // Correspondences window
              TabbedWindow(
                height: constraints.maxHeight*listHeight,
                title: 'Correspondences',
                tabNames: [
                  'prioritized',
                  'recent',
                  'new progress'
                ],
                lists: [
                  TabbedWindowList(
                    listItems: [
                      TabbedWindowListCorrespondence(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'popular owl',
                        description: 'I am an owl',
                      ),
                    ],
                  ),
                  TabbedWindowList(
                    listItems: [
                      TabbedWindowListCorrespondence(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'recent owl',
                        description: 'I am an owl',
                      ),
                    ],
                  ),
                  TabbedWindowList(
                    listItems: [
                      TabbedWindowListCorrespondence(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        name: 'newly progressed owl',
                        description: 'I am an owl',
                      ),
                    ],
                  ),
                ]
              ),
            ],
          );
        }
      ),
    );
  }
}
