import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*class AdaptiveAppBar extends StatefulWidget implements PreferredSizeWidget {
  AdaptiveAppBar({Key? key,})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AdaptiveAppBarState createState() => _AdaptiveAppBarState();

}

class _AdaptiveAppBarState extends State<AdaptiveAppBar> {
  final Image headerLogo = new Image(
      image: new ExactAssetImage('assets/logo_text.png'),
      height: AppBar().preferredSize.height - 30,
      //width: 20.0,
      alignment: FractionalOffset.center
  );
  final List<String> navList = [
    'Dashboard',
    'Organizations',
    'Correspondences',
    'Settings',
    'Logout'
  ];
  final double textSize = 18;


  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.of(context).size.width > 1000;

    return AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
        //title: headerLogo,
        centerTitle: true,
        title: !wide ? headerLogo : PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // logo
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: (AppBar().preferredSize.height - textSize)/2
                ),
                child: headerLogo,
              ),
              for (String page in navList)
                TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.all(
                        (AppBar().preferredSize.height - textSize)/2
                    ),
                    child: Text(
                        page,
                        style: TextStyle (
                          color: Theme.of(context).canvasColor,
                          fontSize: textSize,
                        )
                    ),
                  ),
                )
            ],
          ),
        ),
    );
  }
}*/

final Image headerLogo = new Image(
    image: new ExactAssetImage('assets/logo_text.png'),
    height: AppBar().preferredSize.height - 30,
    alignment: FractionalOffset.center
);
final List<String> navList = [
  'Dashboard',
  'Organizations',
  'Correspondences',
  'Settings',
  'Logout'
];
final double textSize = 18;
final double wideBreakPoint = 1000;

class AdaptiveAppBar extends AppBar{
  final PreferredSizeWidget? bottom;

  AdaptiveAppBar(BuildContext context, {this.bottom}) :super(
    bottom: bottom,
    backgroundColor: Theme.of(context).accentColor,
    iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
    //title: headerLogo,
    centerTitle: true,
    title: !(MediaQuery.of(context).size.width > wideBreakPoint) ? headerLogo : PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // logo
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (AppBar().preferredSize.height - textSize)/2
            ),
            child: headerLogo,
          ),
          for (String page in navList)
            TextButton(
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.all(
                    (AppBar().preferredSize.height - textSize)/2
                ),
                child: Text(
                    page,
                    style: TextStyle (
                      color: Theme.of(context).canvasColor,
                      fontSize: textSize,
                    )
                ),
              ),
            )
        ],
      ),
    ),
  );
}