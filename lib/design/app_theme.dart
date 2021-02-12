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
    // ignoring themes for this build since this breaks everything.... all default text needs to be dark
    return Typography.material2018().black;
  }
}
