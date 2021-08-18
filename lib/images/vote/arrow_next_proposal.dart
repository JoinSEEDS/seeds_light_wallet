import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seeds/constants/app_colors.dart';

class ArrowNextProposal extends CustomPainter {
  const ArrowNextProposal();

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(size.width * 0.5000071, size.height * 0.6836714)
      ..lineTo(size.width * 0.6836821, size.height * 0.5000000)
      ..moveTo(size.width * 0.6836821, size.height * 0.5000000)
      ..lineTo(size.width * 0.5000071, size.height * 0.3163254)
      ..moveTo(size.width * 0.6836821, size.height * 0.5000000)
      ..lineTo(size.width * 0.3163339, size.height * 0.5000000)
      ..moveTo(size.width * 0.9591893, size.height * 0.5000000)
      ..cubicTo(size.width * 0.9591893, size.height * 0.7536000, size.width * 0.7536071, size.height * 0.9591821,
          size.width * 0.5000071, size.height * 0.9591821)
      ..cubicTo(size.width * 0.2464071, size.height * 0.9591821, size.width * 0.04082393, size.height * 0.7536000,
          size.width * 0.04082393, size.height * 0.5000000)
      ..cubicTo(size.width * 0.04082393, size.height * 0.2463986, size.width * 0.2464071, size.height * 0.04081500,
          size.width * 0.5000071, size.height * 0.04081500)
      ..cubicTo(size.width * 0.7536071, size.height * 0.04081500, size.width * 0.9591893, size.height * 0.2463986,
          size.width * 0.9591893, size.height * 0.5000000)
      ..close();

    final Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07142857
      ..color = AppColors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paintStroke);

    final Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.transparent;

    canvas.drawPath(path, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
