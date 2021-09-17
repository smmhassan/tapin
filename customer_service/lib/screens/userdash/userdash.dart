import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/tabbedwindow/TabbedWindow.dart';
import '../../widgets/tabbedwindow/TabbedWindowList.dart';
import '../../widgets/tabbedwindow/TabbedWindowListOrganization.dart';
import '../../widgets/tabbedwindow/TabbedWindowListCorrespondence.dart';
import '../../widgets/DashHeader.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';

class UserDash extends StatefulWidget {
  @override
  _UserDashState createState() => _UserDashState();
}

class _UserDashState extends State<UserDash> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  QueryMutation addMutation = QueryMutation();

  final double mobileHeaderHeight = .12;

  final double mobileListHeight = .36;

  final double mobileTitleHeight = 18;

  final double desktopHeaderHeight = 0.15;

  final double desktopListHeight = 0.6;

  final double desktopTitleHeight = 22;

  final double maxContentWidth = 1200;

  final Image headerLogo = new Image(
      image: new ExactAssetImage('assets/logo_text.png'),
      height: AppBar().preferredSize.height - 30,
      //width: 20.0,
      alignment: FractionalOffset.center
  );

  @override
  Widget build(BuildContext context) {
    /*GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(
          queryMutation.getUser(),
        ),
      ),
    );
    print(result.data);
    if (!result.hasException) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserDash(),
        ),
      );
    }*/

    bool narrow = MediaQuery.of(context).size.width < 600;
    bool wide = MediaQuery.of(context).size.width > 1000;

    List<String> navList = [
      'Dashboard',
      'Organizations',
      'Correspondences',
      'Settings',
      'Logout'
    ];

    return Scaffold(
      appBar: AdaptiveAppBar(context),
      //appBar: AppBar(),

      endDrawer: wide ? null : NavigationDrawer(
        //items: navList,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: Column(
                children: [
                  // backend test --------------
                  /*Query(
                    options: QueryOptions(
                      document: gql(QueryMutation().getUser()),
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      print(result.data);
                      //String username = result?.data?["user"]['username'] ?? 'error';
                      if (result.data != null) {
                        return Text(result.data?["viewer"]["user"]['objectId']);
                      } else{
                        if (result.hasException) {
                          print(result.exception);
                        }
                        return Text('error');
                      }
                    }
                  ),*/
                  // rewards and user info
                  DashHeader(
                    height: narrow ?
                      constraints.maxHeight*mobileHeaderHeight:
                      constraints.maxHeight*desktopHeaderHeight,
                    leftItem: Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: constraints.maxHeight*mobileHeaderHeight*.55,
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
                  SizedBox(
                    height: narrow ?
                      constraints.maxHeight*mobileListHeight*2:
                      constraints.maxHeight*desktopListHeight,
                    child: Flex (
                      children: [
                        // organizations window
                        TabbedWindow(
                          viewAllRoute: '/userorganizations',
                          height: narrow ?
                            constraints.maxHeight*mobileListHeight :
                            constraints.maxHeight*desktopListHeight,
                          title: 'Organizations',
                          titleSize: narrow ?
                            mobileTitleHeight :
                            desktopTitleHeight,
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
                                  dense: narrow ? true : false,
                                ),
                                TabbedWindowListOrganization(
                                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                  name: 'big owl',
                                  dense: narrow ? true : false,
                                ),
                                TabbedWindowListOrganization(
                                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                  name: 'smol owl',
                                  dense: narrow ? true : false,
                                ),
                                TabbedWindowListOrganization(
                                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                  name: 'cool owl',
                                  dense: narrow ? true : false,
                                ),
                              ],
                            ),
                            TabbedWindowList(
                              listItems: [
                                TabbedWindowListOrganization(
                                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                  name: 'popular owl',
                                  dense: narrow ? true : false,
                                ),
                              ],
                            ),
                            TabbedWindowList(
                              listItems: [
                                TabbedWindowListOrganization(
                                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                  name: 'new owl',
                                  dense: narrow ? true : false,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Correspondences window
                        TabbedWindow(
                            viewAllRoute: '/userorganizations',
                            height: narrow ?
                              constraints.maxHeight*mobileListHeight :
                              constraints.maxHeight*desktopListHeight,
                            title: 'Correspondences',
                            titleSize: narrow ?
                              mobileTitleHeight :
                              desktopTitleHeight,
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
                                    dense: narrow ? true : false,
                                  ),
                                ],
                              ),
                              TabbedWindowList(
                                listItems: [
                                  TabbedWindowListCorrespondence(
                                    image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                    name: 'recent owl',
                                    description: 'I am an owl',
                                    dense: narrow ? true : false,
                                  ),
                                ],
                              ),
                              TabbedWindowList(
                                listItems: [
                                  TabbedWindowListCorrespondence(
                                    image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                    name: 'newly progressed owl',
                                    description: 'I am an owl',
                                    dense: narrow ? true : false,
                                  ),
                                ],
                              ),
                            ]
                        ),
                    ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: narrow ?
                        Axis.vertical :
                        Axis.horizontal,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}