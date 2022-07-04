import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class AppColorSchemes {
  // TODO(gguij004): not completed or being used yet, most colors are just there for testing.
  // surface: AppBar color
  static const ColorScheme darkColorScheme = ColorScheme(
    surfaceTint: Colors.brown,
    primaryContainer: AppColors.white,
    background: AppColors.primary,
    onBackground: AppColors.white,
    primary: AppColors.green1,
    onPrimary: AppColors.white,
    secondary: AppColors.primary,
    onSecondary: AppColors.white,
    surface: AppColors.primary,
    onSurface: AppColors.white,
    error: Colors.red,
    onError: Colors.blueAccent,
    brightness: Brightness.dark,
    // errorContainer: Colors.deepOrange,
    // inversePrimary: Colors.deepOrange,
    // inverseSurface: Colors.deepOrange,
    // onErrorContainer: Colors.deepOrange,
    // onInverseSurface: Colors.deepOrange,
    // onPrimaryContainer: Colors.deepOrange,
    // onSecondaryContainer: Colors.deepOrange,
    // onSurfaceVariant: Colors.deepOrange,
    // onTertiary: Colors.deepOrange,
    // onTertiaryContainer: Colors.deepOrange,
    // outline: Colors.deepOrange,
    // secondaryContainer: Colors.deepOrange,
    // shadow: Colors.deepOrange,
    // surfaceVariant: Colors.deepOrange,
    // tertiary: Colors.deepOrange,
    // tertiaryContainer: Colors.deepOrange,
  );

  // TODO(gguij004): not completed, to work on it after the darkScheme.
  static const lightColorScheme = ColorScheme(
    background: Colors.amber,
    primary: Colors.black,
    secondary: Colors.brown,
    surface: Colors.purpleAccent,
    onPrimary: Colors.red,
    onSecondary: Colors.deepOrange,
    onError: Colors.redAccent,
    brightness: Brightness.light,
    onSurface: Colors.redAccent,
    onBackground: Colors.redAccent,
    error: Colors.red,
  );
}
