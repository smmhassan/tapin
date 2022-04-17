import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterToggle extends StatefulWidget {
  final String text;
  //final void Function() onPressed;
  final ValueChanged<bool> onChanged;
  final bool? isChecked;

  const FilterToggle({
    Key? key,
    required this.text,
    //required this.onPressed,
    required this.onChanged,
    this.isChecked,
  }) : super(key: key);

  @override
  _FilterToggleState createState() => _FilterToggleState();
}

class _FilterToggleState extends State<FilterToggle> {

  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onChanged(isSelected);
          //widget.onPressed;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected? Theme.of(context).secondaryHeaderColor : Theme.of(context).accentColor,
            )
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: isSelected? Theme.of(context).buttonColor : Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}