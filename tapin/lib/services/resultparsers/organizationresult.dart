import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class OrganizationResult {
  static int getCount(QueryResult result) {
    return result.data?["organizations"]['count'];
  }

  static String getId(QueryResult result, int i) {
    return result.data?["organizations"]["edges"][i]["node"]["objectId"];
  }

  static String getName(QueryResult result, int i) {
    return result.data?["organizations"]["edges"][i]["node"]["name"];
  }

  static String getImageURL(QueryResult result, int i) {
    return result.data?["organizations"]["edges"][i]["node"]["logo"]["url"];
  }

  static ImageProvider getImage(QueryResult result, int i) {
    return NetworkImage(
        result.data?["organizations"]["edges"][i]["node"]["logo"]["url"]);
  }
}