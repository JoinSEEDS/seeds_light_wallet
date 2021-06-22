import 'package:flutter/rendering.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class TrianglePassValue extends CustomPainter {
  const TrianglePassValue();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.green1
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawShadow(path, AppColors.black, 3.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
