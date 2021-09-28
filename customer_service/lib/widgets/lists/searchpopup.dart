import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class BottomSearchBar extends StatelessWidget {
  final bool visible;

  final double fontSize = 18;

  const BottomSearchBar({
    Key? key,
    //required this.refetchQuery,
    required this.onEntry,
    required this.searchController,
    required this.visible,
  }) : super(key: key);

  //final Function()? refetchQuery;
  final ValueChanged<bool> onEntry;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child:TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted:(value) {
            onEntry(true);
            Navigator.pop(context);
          },
          controller: searchController,
          style: TextStyle(
            fontSize: fontSize,
            color: Theme.of(context).accentColor,
          ),
          cursorColor: Theme.of(context).selectedRowColor,
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.all(0),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                onEntry(true);
                Navigator.pop(context);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}