import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapin/widgets/RoundImage.dart';

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
final double wideBreakPoint = 1250;

class ChatAppBar extends AppBar {
  final PreferredSizeWidget? bottom;
  final ParseUser user;
  final ImageProvider image;
  final String chatName;

  ChatAppBar(BuildContext context, this.user, this.image, this.chatName,
      {this.bottom})
      : super(
          bottom: bottom,
          backgroundColor: Theme.of(context).accentColor,
          iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
          //title: headerLogo,
          //centerTitle: true,
          title: !(MediaQuery.of(context).size.width > wideBreakPoint)
              ? ChatInfo(image: image, chatName: chatName)
              : PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // logo
                      Container(
                        child: ChatInfo(
                          image: image,
                          chatName: chatName,
                        ),
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

class ChatInfo extends StatelessWidget {
  final ImageProvider image;
  final String chatName;

  const ChatInfo({Key? key, required this.image, required this.chatName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: RoundImage(
              image: image,
              color: Theme.of(context).buttonColor,
              size: AppBar().preferredSize.height * .75,
              borderSize: 2,
            ),
          ),
          Expanded(
            child: Text(
              chatName,
              style: TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
