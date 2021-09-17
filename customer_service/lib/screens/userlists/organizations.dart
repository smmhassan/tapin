import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:customer_service/widgets/listtiles/organization.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

final double mobileHeaderHeight = .12;

final double mobileListHeight = .36;

final double mobileTitleHeight = 18;

final double desktopHeaderHeight = 0.15;

final double desktopListHeight = 0.6;

final double desktopTitleHeight = 22;

final double maxContentWidth = 1000;

final Image headerLogo = new Image(
    image: new ExactAssetImage('assets/logo_text.png'),
    height: AppBar().preferredSize.height - 30,
    //width: 20.0,
    alignment: FractionalOffset.center);

class UserOrganizationList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool narrow = screenWidth < 600;
    bool wide = screenWidth > 1000;

    List<Widget> listItems = [
      OrganizationListTile(
        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        name: 'popular owl',
        width: screenWidth,

      ),
      OrganizationListTile(
        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        name: 'not popular owl',
        width: screenWidth,
      ),
      OrganizationListTile(
        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        name: 'standard owl',
        width: screenWidth,
      ),
    ];

    return Scaffold(
        appBar: AdaptiveAppBar(context),
        //appBar: AppBar(),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).accentColor,
        ),

        endDrawer: wide ? null : NavigationDrawer(),
        body: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: ListView(
                children: [
                  for (Widget item in listItems) item,
                ],
              ),
            )
          );
        }
      )
    );
  }
}
