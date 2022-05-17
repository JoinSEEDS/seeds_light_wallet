import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

/// A short flat widget button with rounded corners
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultButtonBorderRadius)),
          child: Text(title),
          onPressed: () => onPressed),
    );
  }
}
