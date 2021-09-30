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
import 'package:google_sign_in/google_sign_in.dart';


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
                        if (result.data?["user"]["displayPicture"]['url'] != null) {
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
                          viewAllRoute: '/userorganizations',
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
                                document: gql(QueryMutation().getOrgs([],"","")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                if (result.data != null && result.data?["organizations"]['count'] > 0) {
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
                                  return TabbedWindowEmpty();
                                }
                              }
                            ),
                            Query(
                                options: QueryOptions(
                                  document: gql(QueryMutation().getOrgs(['administration'],"","")),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null && result.data?["organizations"]['count'] > 0) {
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
                                    return TabbedWindowEmpty();
                                  }
                                }
                            ),
                            Query(
                                options: QueryOptions(
                                  document: gql(QueryMutation().getOrgs(['clubs'],"","")),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null && result.data?["organizations"]['count'] > 0) {
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
                                    return TabbedWindowEmpty();
                                  }
                                }
                            ),
                          ],
                        ),
                        // Correspondences window
                        TabbedWindow(
                          viewAllRoute: '/userorganizations',
                          height: narrow ?
                          constraints.maxHeight*mobileListHeight :
                          constraints.maxHeight*desktopListHeight,
                          title: 'Requests',
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
                                  document: gql(QueryMutation().getCorrespondences(user.objectId.toString(), [], "")),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null && result.data?["chats"]['count'] > 0) {
                                    //print(result.data);
                                    int count = result.data?["chats"]['count'];
                                    return TabbedWindowList(
                                        listItems: [
                                          for (var i = 0; i < count; i++) TabbedWindowListCorrespondence(
                                            name: result.data?["chats"]["edges"][i]["node"]
                                              ["members"]["edges"][0]["node"]["user"]["employee"]
                                              ["organization"]["name"],
                                            description: result.data?["chats"]["edges"][i]["node"]["correspondence"]["summary"],
                                            image: NetworkImage(result.data?["chats"]["edges"][i]["node"]
                                              ["members"]["edges"][0]["node"]["user"]["employee"]
                                              ["organization"]["logo"]["url"]),
                                            dense: narrow ? true : false,
                                          ),
                                        ]
                                    );
                                  }
                                  else {
                                    return TabbedWindowEmpty();
                                  }
                                }
                            ),
                            Query(
                                options: QueryOptions(
                                  document: gql(QueryMutation().getCorrespondences(user.objectId.toString(), ['administration'], "")),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null && result.data?["chats"]['count'] > 0) {
                                    //print(result.data);
                                    int count = result.data?["chats"]['count'];
                                    return TabbedWindowList(
                                        listItems: [
                                          for (var i = 0; i < count; i++) TabbedWindowListCorrespondence(
                                            name: result.data?["chats"]["edges"][i]["node"]
                                            ["members"]["edges"][0]["node"]["user"]["employee"]
                                            ["organization"]["name"],
                                            description: result.data?["chats"]["edges"][i]["node"]["correspondence"]["summary"],
                                            image: NetworkImage(result.data?["chats"]["edges"][i]["node"]
                                            ["members"]["edges"][0]["node"]["user"]["employee"]
                                            ["organization"]["logo"]["url"]),
                                            dense: narrow ? true : false,
                                          ),
                                        ]
                                    );
                                  }
                                  else {
                                    return TabbedWindowEmpty();
                                  }
                                }
                            ),
                            Query(
                                options: QueryOptions(
                                  document: gql(QueryMutation().getCategoryCorrespondences(user.objectId.toString(), ['clubs'])),
                                ),
                                builder: (result, {refetch, fetchMore}) {
                                  if (result.data != null && result.data?["chats"]['count'] > 0) {
                                    //print(result.data);
                                    int count = result.data?["chats"]['count'];
                                    return TabbedWindowList(
                                        listItems: [
                                          for (var i = 0; i < count; i++) TabbedWindowListCorrespondence(
                                            name: result.data?["chats"]["edges"][i]["node"]
                                            ["members"]["edges"][0]["node"]["user"]["employee"]
                                            ["organization"]["name"],
                                            description: result.data?["chats"]["edges"][i]["node"]["correspondence"]["summary"],
                                            image: NetworkImage(result.data?["chats"]["edges"][i]["node"]
                                            ["members"]["edges"][0]["node"]["user"]["employee"]
                                            ["organization"]["logo"]["url"]),
                                            dense: narrow ? true : false,
                                          ),
                                        ]
                                    );
                                  }
                                  else {
                                    return TabbedWindowEmpty();
                                  }
                                }
                            ),
                          ],
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

class TabbedWindowEmpty extends StatelessWidget {
  const TabbedWindowEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'could not find anything',
          style: TextStyle(
              color: Theme.of(context).accentColor
          ),
        )
    );
  }
}