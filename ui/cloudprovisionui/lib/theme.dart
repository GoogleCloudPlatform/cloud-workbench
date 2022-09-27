import 'package:flutter/material.dart';

class CloudTheme {
  ThemeData get themeData {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Color(0xff1a73e8),
      accentColor: Colors.cyan[600],

      // Define the default font family.
      fontFamily: "Google Sans",

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 3,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
        //headline6: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
      ),
    );
  }
}
