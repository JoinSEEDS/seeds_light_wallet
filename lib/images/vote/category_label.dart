import 'package:flutter/rendering.dart';
import 'package:seeds/constants/app_colors.dart';

class CategoryLabel extends CustomPainter {
  const CategoryLabel();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.orangeYellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width - 1, size.height)
      ..lineTo(size.width, size.height - 1)
      ..lineTo(size.width - 10, size.height - 13)
      ..lineTo(size.width, 1)
      ..lineTo(size.width - 1, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
