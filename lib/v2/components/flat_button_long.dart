import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

/// A long flat widget button with rounded corners
class FlatButtonLong extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const FlatButtonLong({Key key, @required this.title, @required this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = color != null
        ? Theme.of(context).textTheme.subtitle2HighEmphasis.copyWith(color: AppColors.springGreen)
        : Theme.of(context).textTheme.subtitle2HighEmphasis;
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        color: color ?? AppColors.springGreen,
        disabledTextColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.springGreen),
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
