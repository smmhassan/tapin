import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.onEntry,
    required this.searchController,
  }) : super(key: key);

  final ValueChanged<String> onEntry;
  final TextEditingController searchController;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final double fontSize = 18;

  bool empty =  true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.searchController.text.length > 0) {
        empty = false;
      }
      else {
        empty = true;
      }
    });
    return Visibility(
      //visible: visible,
      child: Container(
        //padding: EdgeInsets.only(
        //  bottom: MediaQuery.of(context).viewInsets.bottom,
        //),
        child:TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: (text) {
            setState(() {
              if (text.length > 0) {
                empty = false;
              }
              else {
                empty = true;
              }
            });
          },
          onSubmitted:(value) {
            widget.onEntry(widget.searchController.text);
            Navigator.pop(context);
          },
          controller: widget.searchController,
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
                widget.onEntry(widget.searchController.text);
                Navigator.pop(context);
              },
              color: Theme.of(context).accentColor,
            ),
            suffixIcon: empty? null : IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                widget.searchController.clear();
                setState(() {
                  empty = true;
                });
                widget.onEntry(widget.searchController.text);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}