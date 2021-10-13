import 'package:flutter/material.dart';

class AppColors {
  // NEW COLORS, ASK GERY BEFORE ADDING A NEW COLOR-----DarkGreen1
  static const _primaryValue = 0xFF0F2617;

  static const Color primary = MaterialColor(_primaryValue, {
    50: Color(0xff7b887f),
    100: Color(0xff6f7d74),
    200: Color(0xff57675d),
    300: Color(0xff3f5145),
    400: darkGreen3,
    500: Color(_primaryValue),
    600: Color(0xff0d2215),
    700: Color(0xff0c1e12),
    800: Color(0xff0a1b10),
    900: Color(0xff09170e)
  });

  /// Basic Colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  /// Primary Colors
  static const green1 = Color(0xFF1F992A);
  static const green2 = Color(0xFF238C32);
  static const green3 = Color(0xFF2EE53F);

  /// Use Primary Color
  //static const darkGreen1 = Color(0xFF0F2617);
  static const darkGreen2 = Color(0xFF1D3726);
  static const darkGreen3 = Color(0xFF273C2E);
  static const darkGreen4 = Color(0xFF0F1E14);
  static const canopy = Color(0xFF1EAF32);

  /// Lighter Shades
  static const grey1 = Color(0xFF87928B);
  static const grey2 = Color(0xFF8E998C);
  static const grey3 = Color(0xFF9FA8A2);

  static const lightGreen1 = Color(0xFF283D2E);
  static const lightGreen2 = Color(0xFF2B4835);
  static const lightGreen3 = Color(0xFF295431);
  static const lightGreen4 = Color(0xFF12411C);
  static const lightGreen5 = Color(0xFFE7F5DE);
  static const lightGreen6 = Color(0xFF6BB283);

  static const whiteYellow = Color(0xFFFDFFF2);

  /// Gradients
  static final gradientNeonGreen = RadialGradient(
    colors: [
      canopy.withOpacity(0.50),
      canopy.withOpacity(1),
    ],
  );

  static const gradientDarkGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF408055),
      Color(0xFF264D33),
    ],
  );

  static const gradientLightGreen = RadialGradient(
    colors: [
      Color(0xFFE5FFEE),
      Color(0xFFCCFFDD),
    ],
  );

  static const gradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C7E0),
      Color(0xFF007694),
    ],
  );

  /// Status Colors
  static const red1 = Color(0xFFFF2919);
  static const red2 = Color(0xFFBD4545);
  static final deepRed = const Color(0xFFFF2919).withOpacity(0.15);

  static const orangeYellow = Color(0xFFE59900);
  static const tagGreen1 = Color(0xFF1E3326);
  static const tagGreen2 = Color(0xFF113119);
  static const tagGreen3 = Color(0xFF113119);
  static const tagBlue = Color(0xFF239BB2);
  static final muddyYellow = const Color(0xFFE59900).withOpacity(0.15);
  static const subtitle = Color(0xFFCC52CC);

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

  static Color getColorByString(String? str) {
    var hash = 0;
    if (str == null || str.isEmpty) {
      return Colors.grey;
    }
    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
      hash = hash & hash; // Convert to 32bit integer
    }
    final shortened = hash.abs() % 360;
    return HSLColor.fromAHSL(1.0, shortened.toDouble(), 0.3, 0.6).toColor();
  }
}
