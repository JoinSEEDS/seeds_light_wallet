import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class SeedsMaterialWidgetThemes {
  static AppBarTheme get appBarThemeData {
    return const AppBarTheme(elevation: 0.0, titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
  }

  static SnackBarThemeData get snackBarThemeData {
    return const SnackBarThemeData(behavior: SnackBarBehavior.floating);
  }

  // TODO(gguij004): not completed, will fix this theme once I figure out the actual scheme colors,
  // TODO(gguij004):   Themes like this one with so many different colors may need two themes
  static SliderThemeData get sliderDarkThemeData {
    return const SliderThemeData(
      thumbColor: AppColors.white,
      thumbShape: RoundSliderThumbShape(),
      trackHeight: 4.0,
      activeTrackColor: AppColors.green1,
      inactiveTrackColor: AppColors.lightGreen6,
      valueIndicatorColor: AppColors.green1,
    );
  }

  static SliderThemeData get sliderLightThemeData {
    return const SliderThemeData(
      thumbColor: AppColors.white,
      thumbShape: RoundSliderThumbShape(),
      trackHeight: 4.0,
      activeTrackColor: AppColors.green1,
      inactiveTrackColor: AppColors.lightGreen6,
      valueIndicatorColor: AppColors.green1,
    );
  }
}
