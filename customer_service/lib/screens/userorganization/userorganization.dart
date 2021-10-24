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
  ChatResults results = ChatResults();

  /*void getUserOrganizationCorrespondences(String organizationId, String userId, ChatResults results) async {
    var userObject = parse.ParseObject("_User")..set("objectId", userId);
    // get user memberships
    final parse.QueryBuilder<parse.ParseObject> membershipQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('ChatMembership'))
      ..whereEqualTo('user', userObject.toPointer());

    final parse.ParseResponse membershipResponse = await membershipQuery.query();
    if (!membershipResponse.success) {
      setState(() {
        results.fail();
      });
      return;
    }
    else if(membershipResponse.results == null) {
      print("no chat memberships found for the user");
      setState(() {
        results.fail();
      });
      return;
    }

    final userMemberships = membershipResponse.results as List<parse.ParseObject>;
    
    //final organization = organizationResponse.result?.first as parse.ParseObject;
    var organization = parse.ParseObject("Organization")..set("objectId", organizationId);

    // get employees
    final parse.QueryBuilder<parse.ParseObject> employeeQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('Employee'))
      ..whereEqualTo('organization', organization.toPointer());

    final parse.ParseResponse employeeResponse = await employeeQuery.query();
    if (!employeeResponse.success) {
      setState(() {
        results.fail();
      });
      return;
    }
    else if(employeeResponse.results == null) {
      print("employees for the organization not found");
      setState(() {
        results.fail();
      });
      return;
    }

    final employees = employeeResponse.results as List<parse.ParseObject>;
    //print(employees.toString());

    // get employee users
    final parse.QueryBuilder<parse.ParseObject> employeeUserQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('_User'))
      ..whereContainedIn('employee', employees);

    final parse.ParseResponse employeeUserResponse = await employeeUserQuery.query();
    if (!employeeUserResponse.success) {
      setState(() {
        results.fail();
      });
      return;
    }
    else if(employeeUserResponse.results == null) {
      print("employee users for the organization not found");
      setState(() {
        results.fail();
      });
      return;
    }

    final employeeUsers = employeeUserResponse.results as List<parse.ParseObject>;

    // get employee memberships
    final parse.QueryBuilder<parse.ParseObject> employeeMembershipQuery =
    parse.QueryBuilder<parse.ParseObject>(parse.ParseObject('ChatMembership'))
      ..whereContainedIn('user', employeeUsers);

    final parse.ParseResponse employeeMembershipResponse = await employeeMembershipQuery.query();
    if (!employeeMembershipResponse.success) {
      setState(() {
        results.fail();
      });
      return;
    }
    else if(employeeMembershipResponse.results == null) {
      print("employee chat memberships not found");
      setState(() {
        results.fail();
      });
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
      ..whereMatchesKeyInQuery('objectId', 'objectId', employeeChatQuery)
      ..includeObject(['correspondence']);

    final parse.ParseResponse userChatResponse = await userChatQuery.query();
    if (!userChatResponse.success) {
      setState(() {
        results.fail();
      });
    }
    else if (employeeMembershipResponse.results == null) {
      setState(() {
        results.fail();
      });
      print("employees for the organization not found");
    }
    else {
      setState(() {
        results.load(userChatResponse.results as List<parse.ParseObject>);
        print(results);
      });
    }

    // get correspondences

  }*/

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
          ParseQueries().getUserOrganizationCorrespondences(
            (ModalRoute.of(context)!.settings.arguments as UserOrganizationArguments).id,
            user.objectId.toString(),
            (list) {
              setState(() {
                results.load(list);
              });
            },
            () {
              setState(() {
                results.fail();
              });
            }
          );
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
                          (results.status == ResultStatus.loading)? TabbedWindowLoading():
                          (results.status == ResultStatus.failed)? TabbedWindowEmpty():
                          TabbedWindowList(listItems: [
                            for (var i = 0; i < results.list.length; i++)
                              TabbedWindowListCorrespondence(
                              name: results.list[i].get('correspondence').get('summary'),
                              description: results.list[i].get('correspondence').get('summary'),
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