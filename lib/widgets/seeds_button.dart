

import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/widgets/progress_bar.dart';


class SeedsButton extends StatefulWidget {
  final String title;
  final Function? onPressed;
  final bool showProgress;
  final double width;
  final Color color;
  final bool enabled;

  SeedsButton(this.title, {this.onPressed, this.showProgress = false, this.width = 100, this.color = AppColors.green, this.enabled = true});

  @override
  _SeedsButtonState createState() => _SeedsButtonState();
}

class _SeedsButtonState extends State<SeedsButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      width: widget.width,
      child: widget.showProgress && pressed ? ProgressBar() : FlatButton(
        onPressed: widget.enabled ? () {
          setState(() {
            pressed = true;
          });

          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        } : null,
        child: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'worksans',
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 17,
          ),
        ),
        color: widget.color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
