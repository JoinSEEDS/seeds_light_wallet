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

class AppColors {
  static const purple = Color(0xFF5719FF);

  static const lightBlue = Color.fromRGBO(0, 154, 224, 1);
  static const darkBlue = Color.fromRGBO(18, 106, 175, 1);
  static const lightGrey19 = Color.fromRGBO(112,112,112, 0.19);
  static const lightGrey = Color.fromRGBO(242, 242, 242, 1);
  static const black50 = Color.fromRGBO(0, 0, 0, 0.5);

  static const lightGreen = Colors.lightGreen;

  // static const green = Color(0xFF2eb592);
  // static const grey = Color(0xFF9d9d9d);

  static const green = Color(0xFF59B293);
  static const grey = Color(0xFF6C6C6C);

  static const blue = Color(0xFF52AFCC);
  static const orange = Color(0xFFFF9900);
  static const red = Color(0xFFEB5757);
  static const borderGrey = Color(0xFFEBEBEB);
  static const gradient = [green, blue];

  static Color getColorByString(String str) {
    int hash = 0;
    if (str == null || str.length == 0) return Colors.grey;
    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
      hash = hash & hash; // Convert to 32bit integer
    }
    var shortened = hash.abs() % 360;
    return HSLColor.fromAHSL(1.0, shortened.toDouble(), 0.3, 0.6).toColor();
  }
}
