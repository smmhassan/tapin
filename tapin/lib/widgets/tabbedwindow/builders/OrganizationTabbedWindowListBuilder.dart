import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapin/widgets/tabbedwindow/TabbedWindowList.dart';
import 'package:tapin/widgets/tabbedwindow/builders/TabbedWindowLoading.dart';
import 'package:tapin/widgets/tabbedwindow/builders/TabbedWindowEmpty.dart';
import 'package:tapin/widgets/tabbedwindow/TabbedWindowListOrganization.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tapin/services/resultparsers/organizationresult.dart';

class OrganizationTabbedWindowListBuilder extends StatelessWidget {
  final QueryResult result;
  final bool narrow;

  const OrganizationTabbedWindowListBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isLoading) {
      return TabbedWindowLoading();
    } else if (result.data != null && OrganizationResult.getCount(result) > 0) {
      //int count = result.data?["organizations"]['count'];
      int count = OrganizationResult.getCount(result);
      return TabbedWindowList(listItems: [
        for (var i = 0; i < count; i++)
          TabbedWindowListOrganization(
            //name: result.data?["organizations"]["edges"][i]["node"]["name"],
            name: OrganizationResult.getName(result, i),
            //image: NetworkImage(result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]),
            image: OrganizationResult.getImage(result, i),
            dense: narrow ? true : false,
          ),
      ]);
    } else {
      return TabbedWindowEmpty();
    }
  }
}
