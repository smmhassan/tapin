import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortToggle extends StatefulWidget {
  final String text;
  //final void Function() onPressed;
  final ValueChanged<bool> onChanged;
  final bool isChecked;

  const SortToggle({
    Key? key,
    required this.text,
    //required this.onPressed,
    required this.onChanged,
    required this.isChecked,
  }) : super(key: key);

  @override
  _SortToggleState createState() => _SortToggleState();
}

class _SortToggleState extends State<SortToggle> {

  @override
  void initState() {
    //isSelected = widget.isChecked;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onChanged(widget.isChecked);
          //widget.onPressed;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: widget.isChecked? Theme.of(context).secondaryHeaderColor : Theme.of(context).accentColor,
            )
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.isChecked? Theme.of(context).buttonColor : Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}