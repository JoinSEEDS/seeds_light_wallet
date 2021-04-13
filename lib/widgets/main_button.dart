// @dart=2.9

import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class MainButton extends StatefulWidget {
  final double height;
  final double fontSize;
  final String title;
  final EdgeInsets margin;
  final Function onPressed;
  final bool active;

  MainButton({
    Key key,
    @required this.title,
    this.height = 55,
    this.fontSize = 18,
    this.margin,
    this.onPressed,
    this.active = true,
  }): super(key: key);

  @override
  MainButtonState createState() => MainButtonState();
}

class MainButtonState extends State<MainButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: widget.margin,
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
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: LinearGradient(colors: AppColors.gradient)),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              onPressed: widget.active ? widget.onPressed : null,
              color: Colors.transparent,
              child: Container(
                height: widget.height,
                alignment: Alignment.center,
                width: width,
                child: isLoading ? Center(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4.0,
                    ),
                  ),
                ): Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: widget.active ? Colors.white : Colors.grey, fontSize: widget.fontSize),
                ) ,
              ),
            ),
          ),
        ),
      ),
    );
  }

  loading() {
    setState(() {
      isLoading = true;
    });
  }

  done() {
    setState(() {
      isLoading = false;
    });
  }
}
