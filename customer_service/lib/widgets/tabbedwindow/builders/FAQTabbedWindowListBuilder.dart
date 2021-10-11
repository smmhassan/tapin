import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:customer_service/widgets/tabbedwindow/TabbedWindowList.dart';
import 'package:customer_service/widgets/tabbedwindow/builders/TabbedWindowLoading.dart';
import 'package:customer_service/widgets/tabbedwindow/builders/TabbedWindowEmpty.dart';
import 'package:customer_service/widgets/tabbedwindow/TabbedWindowListFAQ.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:customer_service/services/resultparsers/faqresult.dart';


class FAQTabbedWindowListBuilder extends StatelessWidget {
  final QueryResult result;
  final bool narrow;

  const FAQTabbedWindowListBuilder({
    Key? key,
    required this.result,
    required this.narrow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isLoading) {
      return TabbedWindowLoading();
    } else if (result.data != null && FAQResult.getCount(result) > 0) {
      //int count = result.data?["organizations"]['count'];
      int count = FAQResult.getCount(result);
      return TabbedWindowList(listItems: [
        for (var i = 0; i < count; i++)
          TabbedWindowListFAQ(
            question: FAQResult.getQuestion(result, i),
            answer: FAQResult.getShortAnswer(result, i),
            dense: narrow ? true : false,
          ),
      ]);
    } else {
      return TabbedWindowEmpty();
    }
  }
}