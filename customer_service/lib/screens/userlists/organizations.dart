import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:customer_service/widgets/listtiles/organization.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

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

class UserOrganizationList extends StatefulWidget {
  @override
  _UserOrganizationListState createState() => _UserOrganizationListState();
}

class _UserOrganizationListState extends State<UserOrganizationList> {
  //List<String> filters = ['administration', 'health', 'whatever', 'clubs', 'test', 'working', 'organizations', 'trailblazer'];
  List<String> filters = [];
  List<String> selectedFilters = [];

  Future<QueryResult?> Function()? refetchQuery;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool narrow = screenWidth < 600;
    bool wide = screenWidth > 1000;

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
                        return Query(
                            options: QueryOptions(
                              document: gql(QueryMutation().getAllCategories()),
                            ),
                            builder: (result, {refetch, fetchMore}) {
                              if (result.isLoading) {
                                return Center(
                                    child: Text(
                                      "loading...",
                                      style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    )
                                );
                              }
                              if (result.data != null && result.data?["categories"]['count'] > 0) {
                                int count = result.data?["categories"]['count'];
                                //List<String> filters = [];
                                for (int i = 0; i < count; i++) {
                                  if (!filters.contains(result.data?["categories"]["edges"][i]["node"]["name"])) {
                                    filters.add(result.data?["categories"]["edges"][i]["node"]["name"]);
                                  }
                                }
                                return FilterPopup(
                                  filters: filters,
                                  selectedFilters: selectedFilters,
                                  onFilterChanged: (selected) {
                                    setState(() {
                                      selectedFilters = selected;
                                      refetchQuery;
                                      //print(selectedFilters);
                                    });
                                  },
                                  maxHeight: screenHeight/2,
                                  height: 250,
                                );
                              }
                              else {
                                return Center(
                                  child: Text(
                                    "found nothing",
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                );
                              }
                            }
                        );

                          /*FilterPopup(
                            filters: filters,
                            selectedFilters: selectedFilters,
                            onFilterChanged: (selected) {
                              setState(() {
                                selectedFilters = selected;
                                refetchQuery;
                                print(selectedFilters);
                              });
                            },
                          );*/
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
              child: Query(
                options: QueryOptions(
                  document: gql(QueryMutation().getOrgs(selectedFilters,"")),
                ),
                builder: (result, {refetch, fetchMore}) {
                  refetchQuery = refetch;
                  if (result.isLoading) {
                    return Center(
                      child: Text("loading...")
                    );
                  }
                  if (result.data != null && result.data?["organizations"]['count'] > 0) {
                    int count = result.data?["organizations"]['count'];
                    return ListView(
                        children: [
                          for (var i = 0; i < count; i++) OrganizationListTile(
                            name: result.data?["organizations"]["edges"][i]["node"]["name"],
                            image: NetworkImage(result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]),
                            width: screenWidth,
                          ),
                        ]
                    );
                  }
                  else {
                    return Center(
                      child: Text("found nothing"),
                    );
                  }
                }
              ),
              /*ListView(
                children: [
                  for (Widget item in listItems) item,
                ],
              ),*/
            )
          );
        }
      )
    );
  }
}

class FilterPopup extends StatefulWidget {
  final List<String> filters;
  final List<String> selectedFilters;
  final double maxHeight;
  final double height;
  final ValueChanged<List<String>> onFilterChanged;

  const FilterPopup({
    Key? key,
    required this.filters,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.height,
    required this.maxHeight,
  }) : super(key: key);

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  void onFilterPressed(bool selected, String filter) {
    if (selected) {
      setState(() {
        widget.selectedFilters.add(filter);
        //print(widget.selectedFilters);
      });
    }
    else {
      setState(() {
        widget.selectedFilters.remove(filter);
        //print(widget.selectedFilters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
      child: Container (
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          //borderRadius: BorderRadius.vertical(
          //  top: Radius.circular(25),
          //),
        ),
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight,
        ),
        height: widget.height,
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
            Container(
              //decoration: BoxDecoration (
              //  color: Colors.white,
              //),
              height: widget.height-60,

              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.spaceAround,
                  direction: Axis.horizontal,
                  children: [
                    for (String filter in widget.filters)
                      FilterToggle(
                        onChanged: (bool selected) {
                          onFilterPressed(selected, filter);
                          widget.onFilterChanged(widget.selectedFilters);
                        },
                        text: filter,
                        // if the list of filters contains the filter then show it as selected
                        isChecked: widget.selectedFilters.contains(filter)? true : false,
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
  //final void Function() onPressed;
  final ValueChanged<bool> onChanged;
  final bool? isChecked;

  const FilterToggle({
    Key? key,
    required this.text,
    //required this.onPressed,
    required this.onChanged,
    this.isChecked,
  }) : super(key: key);

  @override
  _FilterToggleState createState() => _FilterToggleState();
}

class _FilterToggleState extends State<FilterToggle> {

  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isChecked ?? false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onChanged(isSelected);
          //widget.onPressed;
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

