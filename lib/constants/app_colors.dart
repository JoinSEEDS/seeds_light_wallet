import 'package:flutter/material.dart';

class AppColors {
  // NEW COLORS, ASK GERY BEFORE ADDING A NEW COLOR
  static const _primaryValue = 0xFF0F2617;

  static const Color primary = MaterialColor(_primaryValue, {
    50: Color(0xff7b887f),
    100: Color(0xff6f7d74),
    200: Color(0xff57675d),
    300: Color(0xff3f5145),
    400: Color(0xff273c2e),
    500: Color(_primaryValue),
    600: Color(0xff0d2215),
    700: Color(0xff0c1e12),
    800: Color(0xff0a1b10),
    900: Color(0xff09170e)
  });

  static const springGreen = Color(0xFF1F992A);
  static const jungle = Color(0xFF2B4835);
  static const sand = Color(0xFFFDFFF2);
  static const fern = Color(0xFF238C32);
  static const canopy = Color(0xFF1EAF32);
  static const neonRed = Color(0xFFFF2919);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // DEPRECATED COLORS. DO NOT USE THESE COLORS ANYMORE
  static const purple = Color(0xFF5719FF);

  static const lightBlue = Color.fromRGBO(61, 179, 158, 1);
  static const lightGrey19 = Color.fromRGBO(61, 179, 158, 1);
  static const lightGrey = Color.fromRGBO(242, 242, 242, 1);
  static const black50 = Color.fromRGBO(0, 0, 0, 0.5);

  static const lightGreen = Colors.lightGreen;

  static const green = Color(0xFF59B293);
  static const grey = Color(0xFF6C6C6C);

  static const blue = Color(0xFF3A8BA8);
  static const orange = Color(0xFFFF9900);
  static const red = Color(0xFFEB5757);
  static const borderGrey = Color(0xFFEBEBEB);
  static const gradient = [blue, blue];

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
