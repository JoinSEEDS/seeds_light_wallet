import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';

/// A long flat widget button with rounded corners
class FlatButtonLong extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;
  final bool enabled;

  const FlatButtonLong({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        color: color ?? AppColors.green1,
        disabledTextColor: AppColors.grey1,
        disabledColor: AppColors.darkGreen2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.green1),
        ),
        child: Text(title,
            style: color == null ? Theme.of(context).textTheme.buttonWhiteL : Theme.of(context).textTheme.buttonGreen1),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
