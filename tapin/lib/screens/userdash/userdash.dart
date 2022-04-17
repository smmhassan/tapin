import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapin/widgets/tabbedwindow/TabbedWindow.dart';
import 'package:tapin/widgets/tabbedwindow/builders/OrganizationTabbedWindowListBuilder.dart';
import 'package:tapin/widgets/tabbedwindow/builders/CorrespondenceTabbedWindowListBuilder.dart';

import 'package:tapin/widgets/DashHeader.dart';
import 'package:tapin/widgets/NavigationDrawer.dart';
import 'package:tapin/widgets/AdaptiveAppBar.dart';

import 'package:tapin/services/graphQLConf.dart';
import "package:tapin/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDash extends StatefulWidget {
  @override
  _UserDashState createState() => _UserDashState();
}

class _UserDashState extends State<UserDash> {
  QueryMutation addMutation = QueryMutation();
  final double desktopHeaderHeight = 0.15;
  final double desktopListHeight = 0.6;
  final double desktopTitleHeight = 22;
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  final Image headerLogo = new Image(
      image: new ExactAssetImage('assets/logo3.png'),
      height: AppBar().preferredSize.height - 30,
      //width: 20.0,
      alignment: FractionalOffset.center);

  final double maxContentWidth = 1200;
  final double mobileHeaderHeight = .12;
  final double mobileListHeight = .36;
  final double mobileTitleHeight = 18;
  ParseUser user = ParseUser('', '', '');

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
    return (await Parse().healthCheck()).success;
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AdaptiveAppBar(context, user),
      //appBar: AppBar(),

      endDrawer: wide
          ? null
          : NavigationDrawer(
              user: user,
            ),

      body: LayoutBuilder(builder: (context, constraints) {
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
                      document: gql(
                          QueryMutation().getUserDP(user.objectId.toString())),
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      //print(result.data);
                      //String username = result?.data?["user"]['username'] ?? 'error';
                      if (result.data?["user"]["displayPicture"]['url'] !=
                          null) {
                        ImageProvider dp = NetworkImage(
                            result.data?["user"]["displayPicture"]['url']);
                        return DashHeader(
                          height: narrow
                              ? constraints.maxHeight * mobileHeaderHeight
                              : constraints.maxHeight * desktopHeaderHeight,
                          leftItem: Row(children: [
                            Icon(
                              Icons.attach_money,
                              size: constraints.maxHeight *
                                  mobileHeaderHeight *
                                  .55,
                              color: Theme.of(context).accentColor,
                            ),
                            Text(
                              '100',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ]),
                          image: dp,
                          label: user.username.toString(),
                        );
                      } else {
                        return Text('error');
                      }
                    }),
                SizedBox(
                  height: narrow
                      ? constraints.maxHeight * mobileListHeight * 2
                      : constraints.maxHeight * desktopListHeight,
                  child: Flex(
                    children: [
                      // organizations window
                      TabbedWindow(
                        viewAllRoute: '/userorganizations',
                        height: narrow
                            ? constraints.maxHeight * mobileListHeight
                            : constraints.maxHeight * desktopListHeight,
                        title: 'Organizations',
                        titleSize:
                            narrow ? mobileTitleHeight : desktopTitleHeight,
                        tabNames: [
                          'all',
                          'engineering',
                          'support',
                        ],
                        lists: [
                          Query(
                              options: QueryOptions(
                                document:
                                    gql(QueryMutation().getOrgs([], "", "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return OrganizationTabbedWindowListBuilder(
                                    result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getOrgs(['engineering'], "", "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return OrganizationTabbedWindowListBuilder(
                                    result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getOrgs(['support'], "", "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return OrganizationTabbedWindowListBuilder(
                                    result: result, narrow: narrow);
                              }),
                        ],
                      ),
                      // Correspondences window
                      TabbedWindow(
                        viewAllRoute: '/usercorrespondences',
                        height: narrow
                            ? constraints.maxHeight * mobileListHeight
                            : constraints.maxHeight * desktopListHeight,
                        title: 'Requests',
                        titleSize:
                            narrow ? mobileTitleHeight : desktopTitleHeight,
                        tabNames: [
                          'all',
                          'engineering',
                          'support',
                        ],
                        lists: [
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getCorrespondences(
                                        user.objectId.toString(), [], "", "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return CorrespondenceTabbedWindowListBuilder(
                                    result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getCorrespondences(
                                        user.objectId.toString(),
                                        ['engineering'],
                                        "",
                                        "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return CorrespondenceTabbedWindowListBuilder(
                                    result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getCategoryCorrespondences(
                                        user.objectId.toString(), ['support'])),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return CorrespondenceTabbedWindowListBuilder(
                                    result: result, narrow: narrow);
                              }),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: narrow ? Axis.vertical : Axis.horizontal,
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
