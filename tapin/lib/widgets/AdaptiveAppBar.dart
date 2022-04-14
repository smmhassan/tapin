import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tapin/api/GoogleSignInAPI.dart';

final Image headerLogo = new Image(
    image: new ExactAssetImage('assets/logo3.png'),
    height: AppBar().preferredSize.height - 30,
    alignment: FractionalOffset.center);

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

final double textSize = 18;
final double wideBreakPoint = 1000;

class AdaptiveAppBar extends AppBar {
  final PreferredSizeWidget? bottom;
  final ParseUser user;

  AdaptiveAppBar(BuildContext context, this.user, {this.bottom})
      : super(
          bottom: bottom,
          backgroundColor: Theme.of(context).accentColor,
          iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
          //title: headerLogo,
          centerTitle: true,
          title: !(MediaQuery.of(context).size.width > wideBreakPoint)
              ? headerLogo
              : PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // logo
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                (AppBar().preferredSize.height - textSize) / 2),
                        child: headerLogo,
                      ),
                      for (String page in navList)
                        TextButton(
                          onPressed: () async {
                            if (navRoutes[navList.indexOf(page)] == "/") {
                              ParseResponse response =
                                  await user.logout(deleteLocalUserData: true);
                              if (response.success) {
                                GoogleSignInAPI.logout();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                              }
                            } else {
                              Navigator.pushNamed(
                                  context, navRoutes[navList.indexOf(page)]);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                (AppBar().preferredSize.height - textSize) / 2),
                            child: Text(page,
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontSize: textSize,
                                )),
                          ),
                        )
                    ],
                  ),
                ),
        );
}
