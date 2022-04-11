import 'package:flutter/material.dart';

class OurTheme {
  ThemeData buildTheme() {
    Color _backgroundColor = Color.fromARGB(255, 255, 251, 244);
    Color _cardColor = Color.fromARGB(255, 255, 254, 250);
    Color _disabledColor = Color.fromARGB(255, 240, 236, 228);
    Color _loginText = Color.fromARGB(255, 148, 144, 141);
    Color _bhookBrown = Color.fromARGB(255, 96, 94, 92);
    Color _bhookDarkGreen = Color.fromARGB(255, 115, 182, 147);
    Color _bhookLightGreen = Color.fromARGB(255, 152, 221, 163);
    Color _buttonsColor = Color.fromARGB(255, 133, 201, 169);
    Color _gradientPink = Color.fromARGB(255, 255, 8, 126);
    Color _gradientYellow = Color.fromARGB(255, 255, 246, 20);

    return ThemeData(
      canvasColor: _gradientPink,
      primaryColor: _gradientYellow,
      secondaryHeaderColor: _gradientYellow,
      accentColor: _gradientYellow,
      selectedRowColor: _gradientYellow,
      buttonColor: _gradientYellow,
      cardColor: _gradientYellow,
      disabledColor: _gradientYellow,
      fontFamily: 'Open Sans',
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 96, 94, 92))),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 96, 94, 92)),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 96, 94, 92)),
        ),
      ),
    );
  }
}
