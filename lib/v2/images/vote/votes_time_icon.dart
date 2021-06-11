import 'package:flutter/rendering.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class VotesTimeIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = AppColors.lightGreen3;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4999964, size.height * 0.3622500);
    path_1.lineTo(size.width * 0.4999964, size.height * 0.5000036);
    path_1.lineTo(size.width * 0.5918321, size.height * 0.5459214);
    path_1.moveTo(size.width * 0.7295857, size.height * 0.5000036);
    path_1.cubicTo(size.width * 0.7295857, size.height * 0.6268036, size.width * 0.6267964, size.height * 0.7295964,
        size.width * 0.4999964, size.height * 0.7295964);
    path_1.cubicTo(size.width * 0.3731964, size.height * 0.7295964, size.width * 0.2704032, size.height * 0.6268036,
        size.width * 0.2704032, size.height * 0.5000036);
    path_1.cubicTo(size.width * 0.2704032, size.height * 0.3732036, size.width * 0.3731964, size.height * 0.2704118,
        size.width * 0.4999964, size.height * 0.2704118);
    path_1.cubicTo(size.width * 0.6267964, size.height * 0.2704118, size.width * 0.7295857, size.height * 0.3732036,
        size.width * 0.7295857, size.height * 0.5000036);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = AppColors.green3;
    paint_1_stroke.strokeCap = StrokeCap.round;
    paint_1_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = AppColors.lightGreen3;
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
