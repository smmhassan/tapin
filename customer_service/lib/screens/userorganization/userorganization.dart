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

import '../../widgets/DashHeader.dart';
import '../../widgets/NavigationDrawer.dart';
import '../../widgets/AdaptiveAppBar.dart';

import 'package:customer_service/services/graphQLConf.dart';
import "package:customer_service/services/queryMutation.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart' as parse;

class UserOrganization extends StatefulWidget {
  @override
  _UserOrganizationState createState() => _UserOrganizationState();
}

class _UserOrganizationState extends State<UserOrganization> {
  List<parse.ParseObject> results = <parse.ParseObject>[];
  void getUserOrganizationCorrespondences(String organizationId, String userId) async {
    //print((await parse.Parse().healthCheck()).success);
    // get user memberships
    final parse.QueryBuilder<parse.ParseObject> userQuery =
      parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('User'));
    //  ..whereEqualTo('username', 'owl');

    //userQuery.whereContains('username', 'owl');

    final parse.ParseResponse userResponse = await userQuery.query();
    if (!userResponse.success) {
      return;
    }
    if(userResponse.results == null) {
      print("the user is null");
    }

    final users = userResponse.results?.first as List<parse.ParseObject>;

    print(users.first.toString());
    // get user memberships
    final parse.QueryBuilder<parse.ParseObject> membershipQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('ChatMembership'))
      ..whereRelatedTo('user', 'User', userId);

    final parse.ParseResponse membershipResponse = await membershipQuery.query();
    if (!membershipResponse.success) {
      return;
    }
    if(membershipResponse.results == null) {
      print("it is all null");
    }

    final userMemberships = membershipResponse.results?.first as List<parse.ParseObject>;

    print(userMemberships.first.toString());

    // get employees
    final parse.QueryBuilder<parse.ParseObject> employeeQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('Employee'))
      ..whereRelatedTo('organization', 'Organization', organizationId);

    final parse.ParseResponse employeeResponse = await employeeQuery.query();
    if (!employeeResponse.success) {
      return;
    }
    final employees = membershipResponse.result as List<parse.ParseObject>;

    // get employee users
    final parse.QueryBuilder<parse.ParseObject> employeeUserQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('User'))
      ..whereContainedIn('employee', employees);

    final parse.ParseResponse employeeUserResponse = await employeeUserQuery.query();
    if (!employeeUserResponse.success) {
      return;
    }
    final employeeUsers = employeeUserResponse.results as List<parse.ParseObject>;

    // get employee memberships
    final parse.QueryBuilder<parse.ParseObject> employeeMembershipQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('ChatMembership'))
      ..whereContainedIn('user', employeeUsers);

    final parse.ParseResponse employeeMembershipResponse = await employeeMembershipQuery.query();
    if (!employeeUserResponse.success) {
      return;
    }
    final employeeMemberships = employeeMembershipResponse.results as List<parse.ParseObject>;

    // get chats with user memberships
    final parse.QueryBuilder<parse.ParseObject> employeeChatQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('Chat'))
      ..whereContainedIn('members', employeeMemberships);

    //final parse.ParseResponse employeeChatResponse = await employeeChatQuery.query();
    //if (!employeeChatResponse.success) {
    //  return;
    //}
    //final employeeChats = employeeChatResponse.results as List<parse.ParseObject>;

    // get chats with employee memberships as well
    final parse.QueryBuilder<parse.ParseObject> userChatQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('Chat'))
      ..whereContainedIn('members', userMemberships)
      ..whereMatchesQuery('objectId', employeeChatQuery);

    final parse.ParseResponse userChatResponse = await userChatQuery.query();
    if (!userChatResponse.success) {
      setState(() {
        results.clear();
      });
    } else {
      setState(() {
        results = userChatResponse.results as List<parse.ParseObject>;
      });
    }
    final userChats = userChatResponse.results as List<parse.ParseObject>;

    // get correspondences
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
            as UserOrganizationArguments)
        .id;

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
                      FloatingActionButton(
                        child: const Text('refresh'),
                        onPressed: () {
                          getUserOrganizationCorrespondences(organizationId, user.username.toString());
                        }
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
                          'administration',
                          'clubs',
                        ],
                        lists: [
                          TabbedWindowList(listItems: [
                            for (var i = 0; i < results.length; i++)
                              TabbedWindowListCorrespondence(
                              name: results[i].toString(),
                              description: 'test',
                              image: NetworkImage('https://parsefiles.back4app.com/P8CudbQwTfa32Tc0rxXw3AXHmVPV9EPzIBh3alUB/affa519bc2cb3299ace1ba3ed10bf8ac_trailblazer%20fox%20white%20back.png'),
                              dense: narrow ? true : false,
                              ),
                          ]),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getCorrespondences(
                                    user.objectId.toString(),
                                    ['administration'],
                                    "",
                                    "")),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return CorrespondenceTabbedWindowListBuilder(result: result, narrow: narrow);
                              }),
                          Query(
                              options: QueryOptions(
                                document: gql(QueryMutation()
                                    .getCategoryCorrespondences(
                                    user.objectId.toString(), ['clubs'])),
                              ),
                              builder: (result, {refetch, fetchMore}) {
                                return CorrespondenceTabbedWindowListBuilder(result: result, narrow: narrow);
                              }),
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