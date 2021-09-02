import 'package:flutter/material.dart';

extension TextSizeExtension on Text {
  /// Returns the String size in px
  Size get textSize {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: data, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout();
    return textPainter.size;
  }
}
