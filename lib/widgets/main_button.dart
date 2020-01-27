import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class MainButton extends StatelessWidget {
  final double height;
  final double fontSize;
  final String title;
  final EdgeInsets margin;
  final Function onPressed;

  MainButton({
    @required this.title,
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
          color: Colors.black,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: Offset(0.0, 1.0),
            ),
          ],
        ),
        child: Container(
          width: width,
          child: Container(
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: LinearGradient(colors: AppColors.gradient)),
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
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
