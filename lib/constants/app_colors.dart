import 'package:flutter/material.dart';

const _primaryValue = 0xff2B4835;

const Color primary = MaterialColor(_primaryValue, {
  50: Color(0xffeaedeb),
  100: Color(0xffd5dad7),
  200: Color(0xffaab6ae),
  300: Color(0xff809186),
  400: Color(0xff556d5d),
  500: Color(_primaryValue),
  600: Color(0xff274130),
  700: Color(0xff223a2a),
  800: Color(0xff1e3225),
  900: Color(0xff1a2b20)
});

class AppColors {
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
