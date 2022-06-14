import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final bool filled;
  final double extraSize;

  const Circle({super.key, this.filled = false, this.extraSize = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: extraSize),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
      ),
    );
  }
}
