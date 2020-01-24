import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class EmptyButton extends StatelessWidget {
  final double height;
  final double width;
  final double fontSize;
  final String title;
  final EdgeInsets margin;
  final Function onPressed;
  final Color color;

  EmptyButton({this.title, this.height = 40, this.width, this.fontSize = 18, this.color = AppColors.blue, this.margin, this.onPressed});

  Widget build(BuildContext context) { 
    //final width = MediaQuery.of(context).size.width;
    return Container(
      margin: margin,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: color)
        ),
        child: FlatButton(
          onPressed: onPressed,
          color: Colors.transparent,
          child: Container(
            height: height,
            alignment: Alignment.center,
            child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: fontSize
              )
            ),
          ),
        )
      )
    );
  }
}