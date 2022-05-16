import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

/// A long flat widget button with rounded corners and white outline
class FlatButtonLongOutlined extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const FlatButtonLongOutlined({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
          color: AppColors.tagGreen3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultButtonBorderRadius),
            side: const BorderSide(color: AppColors.green1),
          ),
          onPressed: onPressed,
          child: Text(title, style: Theme.of(context).textTheme.buttonWhiteL)),
    );
  }
}
