import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:customer_service/widgets/listtiles/organization.dart';
import 'package:customer_service/widgets/lists/filterpopup.dart';
import 'package:customer_service/widgets/lists/sortpopup.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';

final double mobileHeaderHeight = .12;

final double mobileListHeight = .36;

final double mobileTitleHeight = 18;

final double desktopHeaderHeight = 0.15;

final double desktopListHeight = 0.6;

final double desktopTitleHeight = 22;

final double maxContentWidth = 1000;

final Map<String, String> sortOptions = {
  "ascending": "name_ASC",
  "descending": "name_DESC",
  "newest first": "createdAt_DESC",
  "oldest first": "createdAt_ASC",
};

final String defaultSort = "name_ASC";

final Iterable<String> sortOptionNames = sortOptions.keys;

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
  List<String> filters = [];
  List<String> selectedFilters = [];

  Future<QueryResult?> Function()? refetchQuery;
  String selectedSortOption = "";

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
                // filter button opens filter popup
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
                      },
                    );
                  },
                ),
                // sort button opens sort popup
                BottomBarButton(
                  text: 'sort',
                  icon: Icons.sort,
                  onPressed: (){
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25)
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SortPopup(
                          sortOptions: sortOptionNames,
                          selectedSortOption: selectedSortOption,
                          onSortOptionChanged: (selected) {
                            setState(() {
                              selectedSortOption = selected;
                              refetchQuery;
                              //print(sortOptions[selectedSortOption]);
                            });
                          },
                          maxHeight: screenHeight/2,
                          height: 200,
                        );
                      },
                    );
                  },
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
              // build organization list
              child: Query(
                options: QueryOptions(
                  document: gql(QueryMutation().getOrgs(selectedFilters,sortOptions[selectedSortOption]??defaultSort,"")),
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


