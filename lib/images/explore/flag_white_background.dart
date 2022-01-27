import 'package:flutter/rendering.dart';
import 'package:seeds/constants/app_colors.dart';

class FlagWhiteBackground extends CustomPainter {
  const FlagWhiteBackground();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = AppColors.white.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.3333333, paint0Fill);

    final Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01666667;
    paint1Stroke.color = const Color(0xffFF2919).withOpacity(1.0);
    paint1Stroke.strokeCap = StrokeCap.round;
    paint1Stroke.strokeJoin = StrokeJoin.round;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.2500000, paint1Stroke);

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.2500000, paint1Fill);

    final Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01666667;
    paint2Stroke.color = const Color(0xffFF2919).withOpacity(1.0);
    paint2Stroke.strokeCap = StrokeCap.round;
    paint2Stroke.strokeJoin = StrokeJoin.round;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.2500000, paint2Stroke);

    final Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.2500000, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
