import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class SecondButton extends StatelessWidget {
  final double height;
  final double fontSize;
  final String title;
  final EdgeInsets margin;
  final Function onPressed;

  SecondButton({
    this.title,
    this.height = 55,
    this.fontSize = 18,
    this.margin,
    this.onPressed,
  });

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: margin,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Container(
          width: width,
          child: Container(
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: AppColors.blue.withOpacity(0.2),
            ),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              onPressed: onPressed,
              color: Colors.transparent,
              child: Container(
                height: height,
                alignment: Alignment.center,
                width: width,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blue, 
                    fontSize: fontSize
                    ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
