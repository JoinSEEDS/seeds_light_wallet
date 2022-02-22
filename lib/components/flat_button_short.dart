import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class FlatButtonShort extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  const FlatButtonShort(
      {Key? key, required this.title, required this.onPressed, this.enabled = true, this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        color: AppColors.green1,
        disabledTextColor: AppColors.grey1,
        disabledColor: AppColors.darkGreen2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: enabled ? onPressed : null,
        child: isLoading
            ? Container(
            width: 17,
            height: 17,
            child: const CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 3,
            ))
            : Text(title, style: Theme.of(context).textTheme.buttonWhiteL),
      ),
    );
  }
}
