import 'package:flutter/cupertino.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'package:customer_service/services/parseresults/ChatResults.dart';

class ParseQueries {
  void getUserOrganizationCorrespondences(
      String organizationId, String userId, Function(List<ParseObject>) load, VoidCallback fail) async {
    var userObject = ParseObject("_User")..set("objectId", userId);
    // get user memberships
    final QueryBuilder<ParseObject> membershipQuery =
        QueryBuilder<ParseObject>(ParseObject('ChatMembership'))
          ..whereEqualTo('user', userObject.toPointer());

    final ParseResponse membershipResponse = await membershipQuery.query();
    if (!membershipResponse.success) {
      fail();
      return;
    } else if (membershipResponse.results == null) {
      print("no chat memberships found for the user");
      fail();
      return;
    }

    final userMemberships = membershipResponse.results as List<ParseObject>;

    //final organization = organizationResponse.result?.first as parse.ParseObject;
    var organization = ParseObject("Organization")
      ..set("objectId", organizationId);

    // get employees
    final QueryBuilder<ParseObject> employeeQuery =
        QueryBuilder<ParseObject>(ParseObject('Employee'))
          ..whereEqualTo('organization', organization.toPointer());

    final ParseResponse employeeResponse = await employeeQuery.query();
    if (!employeeResponse.success) {
      fail();
      return;
    } else if (employeeResponse.results == null) {
      print("employees for the organization not found");
      fail();
      return;
    }

    final employees = employeeResponse.results as List<ParseObject>;
    //print(employees.toString());

    // get employee users
    final QueryBuilder<ParseObject> employeeUserQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereContainedIn('employee', employees);

    final ParseResponse employeeUserResponse = await employeeUserQuery.query();
    if (!employeeUserResponse.success) {
      fail();
      return;
    } else if (employeeUserResponse.results == null) {
      print("employee users for the organization not found");
      fail();
      return;
    }

    final employeeUsers = employeeUserResponse.results as List<ParseObject>;

    // get employee memberships
    final QueryBuilder<ParseObject> employeeMembershipQuery =
        QueryBuilder<ParseObject>(ParseObject('ChatMembership'))
          ..whereContainedIn('user', employeeUsers);

    final ParseResponse employeeMembershipResponse =
        await employeeMembershipQuery.query();
    if (!employeeMembershipResponse.success) {
      fail();
      return;
    } else if (employeeMembershipResponse.results == null) {
      print("employee chat memberships not found");
      fail();
      return;
    }
    final employeeMemberships =
        employeeMembershipResponse.results as List<ParseObject>;

    // get chats with user memberships
    final QueryBuilder<ParseObject> employeeChatQuery =
        QueryBuilder<ParseObject>(ParseObject('Chat'))
          ..whereContainedIn('members', employeeMemberships);

    // get chats with employee memberships as well
    final QueryBuilder<ParseObject> userChatQuery =
        QueryBuilder<ParseObject>(ParseObject('Chat'))
          ..whereContainedIn('members', userMemberships)
          ..whereMatchesKeyInQuery('objectId', 'objectId', employeeChatQuery)
          ..includeObject(['correspondence']);

    final ParseResponse userChatResponse = await userChatQuery.query();
    if (!userChatResponse.success) {
      fail();
    } else if (employeeMembershipResponse.results == null) {
      fail();
      print("employees for the organization not found");
    } else {
      load(userChatResponse.results as List<ParseObject>);
      load(userChatResponse.results as List<ParseObject>);
      print("loaded correspondences");
    }
  }
  
}
