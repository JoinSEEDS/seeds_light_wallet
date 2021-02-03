import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class SeedsAppTheme {
  // TODO: Not completed yet
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'SFProDisplay',
        textTheme: SeedsTextTheme.lightTheme);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'SFProDisplay',
        textTheme: SeedsTextTheme.darkTheme);
  }
}

class SeedsTextTheme {
  // TODO: Not completed yet
  static TextTheme get lightTheme {
    return Typography.material2018().black;
  }

  static TextTheme get darkTheme {
    return Typography.material2018().white;
  }
}
