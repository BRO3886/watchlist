import 'package:flutter/material.dart';

part 'constants.dart';

final lightThemeData = ThemeData(
  fontFamily: 'Montserrat',
  primaryColor: darkGreen,
  accentColor: darkGreen,
  canvasColor: Colors.white,
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
  }),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  indicatorColor: darkBlue,
  buttonColor: darkGreen,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(darkGreen),
      overlayColor: MaterialStateProperty.all(Colors.green.shade100),
    ),
  ),
  buttonTheme: ButtonThemeData(
    disabledColor: Colors.grey[200],
    shape: const StadiumBorder(),
    buttonColor: darkGreen,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const StadiumBorder(),
      primary: darkGreen,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[100],
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
  ),
);

const TextStyle headingText = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: darkBlue,
);

const TextStyle subtitleText = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Colors.grey,
);
