import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class AppColorSchemes {
  // TODO(gguij004): not completed or being used yet, most colors are just there for testing.
  static const ColorScheme darkColorScheme = ColorScheme(
    surfaceTint: Colors.brown,
    primaryContainer: Colors.amber,
    primary: AppColors.purple,
    secondary: AppColors.green1,
    surface: AppColors.primary,
    onSurface: AppColors.white,
    onPrimary: Colors.purple,
    onSecondary: Colors.blueAccent,
    onError: Colors.blueAccent,
    brightness: Brightness.dark,
    error: Colors.deepOrange,
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
    primary: Colors.black,
    secondary: Colors.brown,
    surface: Colors.purpleAccent,
    onPrimary: Colors.red,
    onSecondary: Colors.deepOrange,
    onError: Colors.redAccent,
    brightness: Brightness.light,
    onSurface: Colors.redAccent,
    error: Colors.red,
  );
}
