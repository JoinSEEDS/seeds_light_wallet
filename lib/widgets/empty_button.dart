import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class EmptyButton extends StatelessWidget {
  final double height;
  final double width;
  final double fontSize;
  final String title;
  final EdgeInsets margin;
  final Function onPressed;
  final Color color;
  final double textScaleFactor;

  EmptyButton({
    this.title,
    this.height = 40,
    this.width,
    this.fontSize = 18,
    this.color = AppColors.blue,
    this.margin,
    this.onPressed,
    this.textScaleFactor = 1.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: OutlineButton(
        borderSide: BorderSide(color: color),
        highlightedBorderColor: color,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: fontSize),
          textScaleFactor: textScaleFactor,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: onPressed,
      ),
    );
  }
}
