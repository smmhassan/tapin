import 'dart:ui';

import 'package:graphql_flutter/graphql_flutter.dart';


class FAQResult {
  static int getCount(QueryResult result) {
    return result.data?["organization"]["faq"]["count"];
  }

  static String getShortAnswer(QueryResult result, int i) {
    return result.data?["organization"]["faq"]["edges"][i]["node"]["shortAnswer"];
  }

  static String getId(QueryResult result, int i) {
    return result.data?["organization"]["faq"]["edges"][i]["node"]["objectId"];
  }

  static String getQuestion(QueryResult result, int i) {
    return result.data?["organization"]["faq"]["edges"][i]["node"]["question"];
  }

  static String getLongAnswer(QueryResult result, int i) {
    return result.data?["organization"]["faq"]["edges"][i]["node"]["fullAnswer"];
  }
}