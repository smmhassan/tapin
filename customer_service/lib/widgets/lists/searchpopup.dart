import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class BottomSearchBar extends StatelessWidget {
  const BottomSearchBar({
    Key? key,
    required this.refetchQuery,
    required this.searchController,
  }) : super(key: key);

  final Future<QueryResult?> Function()? refetchQuery;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child:TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (refetchQuery == null)? null : (value) {
          refetchQuery;
        },
        controller: searchController,
        style: TextStyle(
          fontSize: 18.0,
          color: Theme.of(context).accentColor,
        ),
        cursorColor: Theme.of(context).selectedRowColor,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed:(){
              refetchQuery;
              },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}