import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "package:customer_service/constants.dart";

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    kUrl,
    defaultHeaders: {
      'X-Parse-Application-Id': kParseApplicationId,
      'X-Parse-Client-Key': kParseClientKey,
      //'X-Parse-Master-Key': kParseMasterKey, //To be removed?
    },
  );
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(), //FIX!!!!!!
      link: httpLink,
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }
}