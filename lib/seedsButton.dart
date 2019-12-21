import 'package:flutter/material.dart';

import 'customColors.dart';

class SeedsButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  
  SeedsButton(this.title, [ this.onPressed ]);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: FlatButton(
        onPressed: () {
          if (this.onPressed != null) {
            this.onPressed();
          }
        },
        child: Text(
          this.title,
          style: TextStyle(
            fontFamily: "worksans",
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 17,
          ),
        ),
        color: CustomColors.Green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
