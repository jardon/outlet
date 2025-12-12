import 'package:flutter/material.dart';

Color fgColor(context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF303030) // Colors.grey.shade850
      : Colors.white;
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.grey.shade900,
);
