import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tapin/api/GoogleSignInAPI.dart';

class NavigationDrawer extends StatelessWidget {
  final ParseUser user;

  final double cornerRadius = 25;
  final double topPadding = 80;
  final double sidePadding = 20;
  final double dividerThickness = 0.5;
  final List<String> navList = [
    'Dashboard',
    'Organizations',
    'Correspondences',
    'Settings',
    'Logout'
  ];
  final List<String> navRoutes = [
    '/userdash',
    '/userorganizations',
    '/usercorrespondences',
    '/userdash',
    '/'
  ];

  NavigationDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.horizontal(left: Radius.circular(cornerRadius)),
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
            itemCount: navList.length,
            itemBuilder: (context, index) {
              return TextButton(
                style: ButtonStyle(
                  //backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).selectedRowColor),
                ),
                onPressed: () async {
                  if (navRoutes[index] == "/") {
                    ParseResponse response =
                        await user.logout(deleteLocalUserData: true);
                    if (response.success) {
                      GoogleSignInAPI.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    }
                  } else {
                    Navigator.pushNamed(context, navRoutes[index]);
                  }
                },
                child: ListTile(
                  title: Text(
                    navList[index],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).canvasColor,
                    ),
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
