import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Function? onPressed;

  const MainCard({
    this.child,
    this.padding,
    this.margin,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onPressed as void Function()?,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0.0),
          child: child,
        ),
      ),
    );
  }
}
