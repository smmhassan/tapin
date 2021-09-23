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
    double screenHeight = MediaQuery.of(context).size.height;
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

    List<String> filters = ['administration', 'health', 'whatever', 'clubs', 'test', 'working', 'organizations', 'trailblazer'];

    return Scaffold(
        appBar: AdaptiveAppBar(context),
        //appBar: AppBar(),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).accentColor,
          child: Container(
            height: AppBar().preferredSize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomBarButton(
                  text: 'search',
                  icon: Icons.search,
                  onPressed: (){},
                ),
                BottomBarButton(
                  text: 'filter',
                  icon: Icons.filter_alt_outlined,
                  onPressed: (){
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25)
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                          child: Container (
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              //borderRadius: BorderRadius.vertical(
                              //  top: Radius.circular(25),
                              //),
                            ),
                            constraints: BoxConstraints(
                              maxHeight: screenHeight/3,
                            ),
                            //height: screenHeight/3,
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    "filter",
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Divider(
                                    color: Theme.of(context).canvasColor,
                                    thickness: 1,
                                  ),
                                ),
                                Wrap(
                                  spacing: 15,
                                  runSpacing: 15,
                                  alignment: WrapAlignment.spaceBetween,
                                  direction: Axis.horizontal,
                                  children: [
                                    for (String filter in filters) FilterToggle(text: filter),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                BottomBarButton(
                  text: 'sort',
                  icon: Icons.sort,
                  onPressed: (){},
                ),
              ],
            ),
          )
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

class BottomBarButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  final double iconSize = 25;
  final double fontSize = 15;

  const BottomBarButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          //height: AppBar().preferredSize.height,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  icon,
                  color: Theme.of(context).canvasColor,
                  size: iconSize,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterToggle extends StatefulWidget {
  final String text;

  const FilterToggle({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _FilterToggleState createState() => _FilterToggleState();
}

class _FilterToggleState extends State<FilterToggle> {

  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected? Theme.of(context).secondaryHeaderColor : Theme.of(context).accentColor,
          )
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: isSelected? Theme.of(context).buttonColor : Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}

