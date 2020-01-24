import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  MainCard({this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.075),
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: Offset(0.0, 1.0,),
          )
        ],
      ),
      padding: padding,
      child: child
    );
  }
}