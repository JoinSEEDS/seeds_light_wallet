import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/widgets/progress_bar.dart';


class SeedsButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final bool showProgress;
  final double width;
  final Color color;

  SeedsButton(this.title, [this.onPressed, this.showProgress = false, this.width = 100, this.color = CustomColors.Green]);

  @override
  _SeedsButtonState createState() => _SeedsButtonState();
}

class _SeedsButtonState extends State<SeedsButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      width: this.widget.width,
      child: this.widget.showProgress && this.pressed ? ProgressBar() : FlatButton(
        onPressed: () {
          setState(() {
            pressed = true;
          });

          if (this.widget.onPressed != null) {
            this.widget.onPressed();
          }
        },
        child: Text(
          this.widget.title,
          style: TextStyle(
            fontFamily: "worksans",
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 17,
          ),
        ),
        color: this.widget.color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
