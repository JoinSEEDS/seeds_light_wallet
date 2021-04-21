import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

/// A long flat widget button with rounded corners
class FlatButtonLong extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;

  const FlatButtonLong({Key? key, required this.title, required this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        color: color ?? AppColors.green1,
        disabledTextColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.green1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(title, style: Theme.of(context).textTheme.button),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
