import 'package:flutter/material.dart';

const _primaryValue = 0xff34cba5;

const Color primary = MaterialColor(_primaryValue, {
  50: Color(0xffebfaf6),
  100: Color(0xffd6f5ed),
  200: Color(0xffaeeadb),
  300: Color(0xff85e0c9),
  400: Color(0xff5dd5b7),
  500: Color(_primaryValue),
  600: Color(0xff2aa284),
  700: Color(0xff1f7a63),
  800: Color(0xff155142),
  900: Color(0xff0a2921)
});

class CustomColors {
  static const lightBlue = Color.fromRGBO(61, 179, 158, 1);
  static const darkBlue = Color.fromRGBO(61, 179, 158, 1);
  static const lightGrey19 = Color.fromRGBO(61, 179, 158, 1);
  static const lightGrey = Color.fromRGBO(242, 242, 242, 1);
  static const grey = Color.fromRGBO(157, 157, 157, 1);
  static const black50 = Color.fromRGBO(0, 0, 0, 0.5);
  static const green = Color.fromRGBO(46, 181, 146, 1);

  static const lightGreen = Colors.lightGreen;
}
