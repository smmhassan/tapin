import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "package:tapin/constants.dart";

HttpLink httpLink = HttpLink(
  'https://tapin.b4a.io/graphql',
  defaultHeaders: {
    'X-Parse-Application-Id': kParseApplicationId,
    'X-Parse-Client-Key': kParseClientKey,
    //'X-Parse-Master-Key': kParseMasterKey, //To be removed?
  },
);

class GraphQLConfiguration {
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
