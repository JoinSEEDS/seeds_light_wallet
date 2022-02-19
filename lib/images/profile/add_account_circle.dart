import 'package:flutter/rendering.dart';
import 'package:seeds/design/app_colors.dart';

class AddAccountCircle extends CustomPainter {
  const AddAccountCircle();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.white;

    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.4916667, paint1Stroke);

    final Path path = Path()
      ..moveTo(size.width * 0.5000000, size.height * 0.3400000)
      ..lineTo(size.width * 0.5000000, size.height * 0.6500000)
      ..moveTo(size.width * 0.3400000, size.height * 0.5000000)
      ..lineTo(size.width * 0.6500000, size.height * 0.5000000);

    final Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
