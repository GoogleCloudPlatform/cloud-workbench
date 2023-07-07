import 'package:flutter/material.dart';

class CloudTheme {
  ThemeData get themeData {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Color.fromRGBO(51, 103, 214, 1),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Color.fromRGBO(51, 103, 214, 1)),

      // Define the default font family.
      //fontFamily: "Open Sans",
      fontFamily: "Roboto",
      //scaffoldBackgroundColor: Color(0xFFF6F7F9), // F6F7F9FF
      scaffoldBackgroundColor: Colors.white70, // F6F7F9FF

      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 3,
        backgroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(51, 103, 214, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            textStyle: TextStyle(fontSize: 16)),
      ),
      cardTheme: CardTheme(
        shadowColor: Colors.black54,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
