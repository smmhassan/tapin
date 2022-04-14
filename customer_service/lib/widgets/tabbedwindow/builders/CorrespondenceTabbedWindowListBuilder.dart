import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapin/widgets/tabbedwindow/TabbedWindowList.dart';
import 'package:tapin/widgets/tabbedwindow/builders/TabbedWindowLoading.dart';
import 'package:tapin/widgets/tabbedwindow/builders/TabbedWindowEmpty.dart';
import 'package:tapin/widgets/tabbedwindow/TabbedWindowListCorrespondence.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:tapin/services/resultparsers/correspondenceresult.dart';

class CorrespondenceTabbedWindowListBuilder extends StatelessWidget {
  final QueryResult result;
  final bool narrow;

  const CorrespondenceTabbedWindowListBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isLoading) {
      return TabbedWindowLoading();
    } else if (result.data != null &&
        CorrespondenceResult.getCount(result) > 0) {
      //print(result.data);
      int count = CorrespondenceResult.getCount(result);
      return TabbedWindowList(listItems: [
        for (var i = 0; i < count; i++)
          TabbedWindowListCorrespondence(
            name: CorrespondenceResult.getName(result, i),
            description: CorrespondenceResult.getSummary(result, i),
            image: CorrespondenceResult.getImage(result, i),
            dense: narrow ? true : false,
          ),
      ]);
    } else {
      return TabbedWindowEmpty();
    }
  }
}
