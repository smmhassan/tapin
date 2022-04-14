import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapin/widgets/lists/sorttoggle.dart';

class SortPopup extends StatefulWidget {
  final Iterable<String> sortOptions;
  final String? selectedSortOption;
  final double maxHeight;
  final double height;
  final ValueChanged<String> onSortOptionChanged;

  const SortPopup({
    Key? key,
    required this.sortOptions,
    this.selectedSortOption,
    required this.onSortOptionChanged,
    required this.height,
    required this.maxHeight,
  }) : super(key: key);

  @override
  _SortPopupState createState() => _SortPopupState();
}

class _SortPopupState extends State<SortPopup> {
  void onSortOptionPressed(bool selected, String option) {
    if (selected) {
      setState(() {
        selectedOption = option;
        //print(widget.selectedFilters);
      });
    } else {
      setState(() {
        selectedOption = "";
        //print(widget.selectedFilters);
      });
    }
  }

  String selectedOption = "";

  @override
  void initState() {
    selectedOption = widget.selectedSortOption ?? "";
    super.initState();
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
                "Sort",
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
                    for (String option in widget.sortOptions)
                      SortToggle(
                        onChanged: (bool selected) {
                          setState(() {
                            if (selectedOption == option) {
                              selectedOption = "";
                            } else {
                              selectedOption = option;
                            }
                            widget.onSortOptionChanged(selectedOption);
                          });
                        },
                        text: option,
                        // if the list of filters contains the filter then show it as selected
                        isChecked: (selectedOption == option),
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
