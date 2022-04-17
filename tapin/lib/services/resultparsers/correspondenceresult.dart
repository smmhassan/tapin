import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class CorrespondenceResult {
  static int getCount(QueryResult result) {
    return result.data?["userchats"]['count'];
  }

  static String getSummary(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["correspondence"]
    ["summary"];
  }

  static String getId(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["correspondence"]
    ["objectId"];
  }

  static String getName(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["members"]["edges"][0]
    ["node"]["user"]["employee"]["organization"]["name"];
  }

  static String getImageURL(QueryResult result, int i) {
    return result.data?["userchats"]["edges"][i]["node"]["members"]["edges"][0]
    ["node"]["user"]["employee"]["organization"]["logo"]["url"];
  }

  static ImageProvider getImage(QueryResult result, int i) {
    return NetworkImage(result.data?["userchats"]["edges"][i]["node"]["members"]
    ["edges"][0]["node"]["user"]["employee"]["organization"]["logo"]
    ["url"]);
  }
}