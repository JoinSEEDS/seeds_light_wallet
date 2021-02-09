import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class SeedsAppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'SFProDisplay',
        textTheme: SeedsTextTheme.lightTheme,
        brightness: Brightness.light);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'SFProDisplay',
        textTheme: SeedsTextTheme.darkTheme,
        brightness: Brightness.dark);
  }
}

// # w100 Thin, the least thick
// # w200 Extra-light
// # w300 Light
// # w400 Normal / regular / plain
// # w500 Medium
// # w600 Semi-bold
// # w700 Bold
// # w800 Extra-bold
// # w900 Black, the most thick
class SeedsTextTheme {
  static TextTheme get lightTheme {
    return Typography.material2018()
        .englishLike
        .copyWith(
          headline3:
              Typography.material2018().englishLike.headline3.copyWith(fontSize: 42, fontWeight: FontWeight.w600),
          headline4:
              Typography.material2018().englishLike.headline4.copyWith(fontSize: 36, fontWeight: FontWeight.w500),
          headline5:
              Typography.material2018().englishLike.headline5.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
          headline6:
              Typography.material2018().englishLike.headline6.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
          subtitle1:
              Typography.material2018().englishLike.subtitle1.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          subtitle2:
              Typography.material2018().englishLike.subtitle2.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          button: Typography.material2018().englishLike.button.copyWith(fontSize: 16),
        )
        .apply(displayColor: Colors.black, bodyColor: Colors.black);
  }

  static TextTheme get darkTheme {
    return Typography.material2018()
        .englishLike
        .copyWith(
          headline3:
              Typography.material2018().englishLike.headline3.copyWith(fontSize: 42, fontWeight: FontWeight.w600),
          headline4:
              Typography.material2018().englishLike.headline4.copyWith(fontSize: 36, fontWeight: FontWeight.w500),
          headline5:
              Typography.material2018().englishLike.headline5.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
          headline6:
              Typography.material2018().englishLike.headline6.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
          subtitle1:
              Typography.material2018().englishLike.subtitle1.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          subtitle2:
              Typography.material2018().englishLike.subtitle2.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          button: Typography.material2018().englishLike.button.copyWith(fontSize: 16),
        )
        .apply(displayColor: Colors.white, bodyColor: Colors.white);
  }
}

// Make sure to import this file in order to use this text styles
// https://dart.dev/guides/language/extension-methods
extension CustomStyles on TextTheme {
  TextStyle get headline7 => const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  TextStyle get headline7LowEmphasis => const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  TextStyle get headline8 => const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  TextStyle get subtitle1HighEmphasis =>
      Typography.material2018().englishLike.subtitle1.copyWith(fontSize: 18, fontWeight: FontWeight.w600);

  TextStyle get subtitle2HighEmphasis =>
      Typography.material2018().englishLike.subtitle2.copyWith(fontSize: 14, fontWeight: FontWeight.w500);

  TextStyle get subtitle2LowEmphasis =>
      Typography.material2018().englishLike.subtitle2.copyWith(fontSize: 14, fontWeight: FontWeight.w300);

  TextStyle get button1 =>
      Typography.material2018().englishLike.button.copyWith(fontSize: 25, fontWeight: FontWeight.w400);
}
