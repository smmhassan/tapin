import 'package:flutter/material.dart';

class OurTheme{
  ThemeData buildTheme(){
    Color _backgroundColor = Color.fromARGB(255, 255, 251, 245);
    Color _loginText = Color.fromARGB(255, 148, 144, 141);
    Color _bhookBrown = Color.fromARGB(255, 96, 94, 92);
    Color _bhookDarkGreen = Color.fromARGB(255, 115, 182, 147);
    Color _bhookLightGreen = Color.fromARGB(255, 152, 221, 163);
    Color _buttonsColor = Color.fromARGB(255, 133, 201, 169);

    return ThemeData(
      canvasColor: _backgroundColor,
      primaryColor: _bhookLightGreen,
      secondaryHeaderColor: _bhookDarkGreen,
      accentColor: _bhookBrown,
      selectedRowColor: _loginText,
      buttonColor: _buttonsColor,
      fontFamily: 'Roboto',
    );
  }
}