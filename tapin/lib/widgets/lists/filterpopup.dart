import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapin/widgets/lists/filtertoggle.dart';

class FilterPopup extends StatefulWidget {
  final List<String> filters;
  final List<String> selectedFilters;
  final double maxHeight;
  final double height;
  final ValueChanged<List<String>> onFilterChanged;

  const FilterPopup({
    Key? key,
    required this.filters,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.height,
    required this.maxHeight,
  }) : super(key: key);

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  void onFilterPressed(bool selected, String filter) {
    if (selected) {
      setState(() {
        widget.selectedFilters.add(filter);
        //print(widget.selectedFilters);
      });
    } else {
      setState(() {
        widget.selectedFilters.remove(filter);
        //print(widget.selectedFilters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double itemSpacing = 20;
    double cornerRadius = 25;
    double padding = 15;
    double titleFontSize = 15;
    double dividerBottomPadding = 10;
    double scrollViewSizeOffset = 60;

    double height =
        (widget.height > widget.maxHeight) ? widget.maxHeight : widget.height;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(cornerRadius),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: padding,
          left: padding,
          right: padding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          //borderRadius: BorderRadius.vertical(
          //  top: Radius.circular(25),
          //),
        ),
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight,
        ),
        height: widget.height,
        child: Column(
          children: [
            Container(
              child: Text(
                "filter",
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: titleFontSize,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: dividerBottomPadding),
              child: Divider(
                color: Theme.of(context).canvasColor,
                thickness: 1,
              ),
            ),
            Container(
              //decoration: BoxDecoration (
              //  color: Colors.white,
              //),
              height: height - scrollViewSizeOffset,

              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: itemSpacing,
                  runSpacing: itemSpacing,
                  alignment: WrapAlignment.spaceAround,
                  direction: Axis.horizontal,
                  children: [
                    for (String filter in widget.filters)
                      FilterToggle(
                        onChanged: (bool selected) {
                          onFilterPressed(selected, filter);
                          widget.onFilterChanged(widget.selectedFilters);
                        },
                        text: filter,
                        // if the list of filters contains the filter then show it as selected
                        isChecked: widget.selectedFilters.contains(filter)
                            ? true
                            : false,
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
