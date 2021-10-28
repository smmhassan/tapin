import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'arguments.dart';

import '../../widgets/tabbedwindow/TabbedWindow.dart';
import 'package:customer_service/widgets/tabbedwindow/TabbedWindowList.dart';
import 'package:customer_service/widgets/tabbedwindow/TabbedWindowListCorrespondence.dart';
import 'package:customer_service/widgets/tabbedwindow/builders/CorrespondenceTabbedWindowListBuilder.dart';
import 'package:customer_service/widgets/tabbedwindow/builders/FAQTabbedWindowListBuilder.dart';
import 'package:customer_service/widgets/tabbedwindow/builders/TabbedWindowEmpty.dart';
import 'package:customer_service/widgets/tabbedwindow/builders/TabbedWindowLoading.dart';


import '../../widgets/DashHeader.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart' as parse;

import 'package:customer_service/services/parseresults/ChatResults.dart';
import 'package:customer_service/services/parseresults/ResultStatus.dart';
import 'package:customer_service/services/ParseQueries.dart';

class UserOrganization extends StatefulWidget {
  @override
  _UserOrganizationState createState() => _UserOrganizationState();
}

class _UserOrganizationState extends State<UserOrganization> {
  ChatResults allCorrespondences = ChatResults();
  void refreshAllCorrespondences() {
    ParseQueries().getUserOrganizationCorrespondences(
        (ModalRoute.of(context)!.settings.arguments as UserOrganizationArguments).id,
        user.objectId.toString(),
        (list) {setState(() {allCorrespondences.load(list);});},
        () {setState(() {allCorrespondences.fail();});},
        1,
    );
  }
  ChatResults activeCorrespondences = ChatResults();
  void refreshActiveCorrespondences() {
    ParseQueries().getUserOrganizationCorrespondences(
      (ModalRoute.of(context)!.settings.arguments as UserOrganizationArguments).id,
      user.objectId.toString(),
          (list) {setState(() {activeCorrespondences.load(list);});},
          () {setState(() {activeCorrespondences.fail();});},
      2,
    );
  }
  ChatResults closedCorrespondences = ChatResults();
  void refreshClosedCorrespondences() {
    ParseQueries().getUserOrganizationCorrespondences(
      (ModalRoute.of(context)!.settings.arguments as UserOrganizationArguments).id,
      user.objectId.toString(),
          (list) {setState(() {closedCorrespondences.load(list);});},
          () {setState(() {closedCorrespondences.fail();});},
      3,
    );
  }

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
      alignment: FractionalOffset.center);

  parse.ParseUser user = parse.ParseUser('', '', '');

  @override
  void initState() {
    initData().then((bool success) {
      parse.ParseUser.currentUser().then((currentUser) {
        setState(() {
          user = currentUser;
          refreshAllCorrespondences();
          refreshActiveCorrespondences();
          refreshClosedCorrespondences();
        });
      });
    }).catchError((dynamic _) {});
    super.initState();
  }

  Future<bool> initData() async {
    return (await parse.Parse().healthCheck()).success;
  }

  @override
  Widget build(BuildContext context) {
    final String organizationId = (ModalRoute.of(context)!.settings.arguments
            as UserOrganizationArguments).id;

    bool narrow = MediaQuery.of(context).size.width < 600;
    bool wide = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      appBar: AdaptiveAppBar(context, user),
      //appBar: AppBar(),

      endDrawer: wide
          ? null
          : NavigationDrawer(
              user: user,
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('New Request'),
        icon: const Icon(Icons.chat_rounded),
        backgroundColor: Theme.of(context).buttonColor,
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
                      document: gql(QueryMutation().getOrgByID(organizationId)),
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      //print(result.data);
                      //String username = result?.data?["user"]['username'] ?? 'error';
                      if (result.data?["organization"] != null) {
                        ImageProvider dp = NetworkImage(
                            result.data?["organization"]["logo"]['url']);
                        String name = result.data?["organization"]["name"];
                        return DashHeader(
                          height: narrow
                              ? constraints.maxHeight * mobileHeaderHeight
                              : constraints.maxHeight * desktopHeaderHeight,
                          leftItem: Container(),
                          image: dp,
                          label: name,
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
                          'active',
                          'closed',
                        ],
                        lists: [
                          // all
                          (allCorrespondences.status == ResultStatus.loading)? TabbedWindowLoading():
                          (allCorrespondences.status == ResultStatus.failed)? TabbedWindowEmpty():
                          TabbedWindowList(listItems: [
                            for (var i = 0; i < allCorrespondences.list.length; i++)
                              TabbedWindowListCorrespondence(
                              name: allCorrespondences.list[i].get('correspondence').get('summary'),
                              description: allCorrespondences.list[i].get('correspondence').get('summary'),
                              dense: narrow ? true : false,
                              ),
                          ]),
                          // active
                          (activeCorrespondences.status == ResultStatus.loading)? TabbedWindowLoading():
                          (activeCorrespondences.status == ResultStatus.failed)? TabbedWindowEmpty():
                          TabbedWindowList(listItems: [
                            for (var i = 0; i < activeCorrespondences.list.length; i++)
                              TabbedWindowListCorrespondence(
                                name: activeCorrespondences.list[i].get('correspondence').get('summary'),
                                description: activeCorrespondences.list[i].get('correspondence').get('summary'),
                                dense: narrow ? true : false,
                              ),
                          ]),
                          // closed
                          (closedCorrespondences.status == ResultStatus.loading)? TabbedWindowLoading():
                          (closedCorrespondences.status == ResultStatus.failed)? TabbedWindowEmpty():
                          TabbedWindowList(listItems: [
                            for (var i = 0; i < closedCorrespondences.list.length; i++)
                              TabbedWindowListCorrespondence(
                                name: closedCorrespondences.list[i].get('correspondence').get('summary'),
                                description: closedCorrespondences.list[i].get('correspondence').get('summary'),
                                dense: narrow ? true : false,
                              ),
                          ]),
                        ],
                      ),
                      // FAQ window
                      TabbedWindow(
                        viewAllRoute: '/usercorrespondences',
                        height: narrow
                            ? constraints.maxHeight * mobileListHeight
                            : constraints.maxHeight * desktopListHeight,
                        title: 'FAQs',
                        titleSize:
                        narrow ? mobileTitleHeight : desktopTitleHeight,
                        tabNames: [
                          'all',
                          'administration',
                          'clubs',
                        ],
                        lists: [
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getOrgFAQs(
                                    organizationId, [], "", "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return FAQTabbedWindowListBuilder(result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getOrgFAQs(
                                    organizationId,['administration'],"","")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return FAQTabbedWindowListBuilder(result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getOrgFAQs(
                                    organizationId, ['clubs'], '', '')),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return FAQTabbedWindowListBuilder(result: result, narrow: narrow);
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