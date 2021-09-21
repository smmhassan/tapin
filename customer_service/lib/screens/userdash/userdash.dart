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
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

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

  ParseUser user = ParseUser('','','');

  @override
  void initState() {
    initData().then((bool success) {
      ParseUser.currentUser().then((currentUser) {
        setState(() {
          user = currentUser;
        });
      });
    }).catchError((dynamic _) {});
    super.initState();
  }

  Future<bool> initData() async {
    /*await Parse().initialize(
      keyParseApplicationId,
      keyParseServerUrl,
      clientKey: keyParseClientKey,
      debug: keyDebug,
    );*/

    return (await Parse().healthCheck()).success;
  }

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
    //String name = 'missing';
    //if (authUser.username != null) {
    //  name = authUser.username.toString();
    //}

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
                  // rewards and user info
                  Query(
                      options: QueryOptions(
                        document: gql(QueryMutation().getUserDP(user.objectId.toString())),
                      ),
                      builder: (result, {refetch, fetchMore}) {
                        //print(result.data);
                        //String username = result?.data?["user"]['username'] ?? 'error';
                        if (result.data != null) {
                          ImageProvider dp = NetworkImage(result.data?["user"]["displayPicture"]['url']);
                          return DashHeader(
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
                            image: dp,
                            label: user.username.toString(),
                          );
                        } else{
                          if (result.hasException) {
                            print(result.exception);
                          }
                          return Text('error');
                        }
                      }
                  ),
                  SizedBox(
                    height: narrow ?
                      constraints.maxHeight*mobileListHeight*2:
                      constraints.maxHeight*desktopListHeight,
                    child: Flex (
                      children: [
                        // organizations window
                        TabbedWindow(
                          height: narrow ?
                          constraints.maxHeight*mobileListHeight :
                          constraints.maxHeight*desktopListHeight,
                          title: 'Organizations',
                          titleSize: narrow ?
                          mobileTitleHeight :
                          desktopTitleHeight,
                          tabNames: [
                            'all',
                            'administration',
                            'clubs',
                          ],
                          lists: [
                            Query(
                              options: QueryOptions(
                                document: gql(QueryMutation().getAllOrgs()),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                if (result.data != null) {
                                  int count = result.data?["organizations"]['count'];
                                  return TabbedWindowList(
                                      listItems: [
                                        for (var i = 0; i < count; i++) TabbedWindowListOrganization(
                                          name: result.data?["organizations"]["edges"][i]["node"]["name"],
                                          image: NetworkImage(result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]),
                                          dense: narrow ? true : false,
                                        ),
                                      ]
                                  );
                                }
                                else {
                                  return Text('ERROR');
                                }
                              }
                            ),
                            Query(
                                options: QueryOptions(
                                  document: gql(QueryMutation().getCategoryOrgs('administration')),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null) {
                                    int count = result.data?["organizations"]['count'];
                                    return TabbedWindowList(
                                        listItems: [
                                          for (var i = 0; i < count; i++) TabbedWindowListOrganization(
                                            name: result.data?["organizations"]["edges"][i]["node"]["name"],
                                            image: NetworkImage(result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]),
                                            dense: narrow ? true : false,
                                          ),
                                        ]
                                    );
                                  }
                                  else {
                                    return Text('ERROR');
                                  }
                                }
                            ),
                            Query(
                                options: QueryOptions(
                                  document: gql(QueryMutation().getCategoryOrgs('clubs')),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null) {
                                    int count = result.data?["organizations"]['count'];
                                    return TabbedWindowList(
                                        listItems: [
                                          for (var i = 0; i < count; i++) TabbedWindowListOrganization(
                                            name: result.data?["organizations"]["edges"][i]["node"]["name"],
                                            image: NetworkImage(result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]),
                                            dense: narrow ? true : false,
                                          ),
                                        ]
                                    );
                                  }
                                  else {
                                    return Text('ERROR');
                                  }
                                }
                            ),
                          ],
                        ),
                        // Correspondences window
                        TabbedWindow(
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