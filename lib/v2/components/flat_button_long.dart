import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/constants/app_colors.dart';

/// A long flat widget button with rounded corners
class FlatButtonLong extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const FlatButtonLong({Key key, @required this.title, @required this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = color != null
        ? Theme.of(context).textTheme.button.copyWith(color: AppColors.green1)
        : Theme.of(context).textTheme.button;
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: color ?? AppColors.green1,
        disabledTextColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.green1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(title, style: style),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
