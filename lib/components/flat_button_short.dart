import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

/// A short flat widget button with rounded corners
class FlatButtonShort extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  const FlatButtonShort({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: MaterialButton(
      color: AppColors.green1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultButtonBorderRadius)),
      onPressed: enabled ? onPressed : null,
      child: isLoading
          ? Container(
              width: 17, height: 17, child: const CircularProgressIndicator(color: AppColors.white, strokeWidth: 3))
          : Text(title, style: Theme.of(context).textTheme.buttonWhiteL),
    ));
  }
}
