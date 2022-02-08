import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:seeds/design/app_colors.dart';

class InviteLinkSuccess extends CustomPainter {
  const InviteLinkSuccess();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint3Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.white;

    canvas.drawCircle(
        Offset(size.width * 0.5000000, size.height * 0.5000000), (size.width + 10) * 0.4838710, paint3Fill);

    final Path path_0 = Path()
      ..moveTo(size.width, size.height * 0.5000000)
      ..cubicTo(
          size.width, size.height * 0.7761429, size.width * 0.7761429, size.height, size.width * 0.5000000, size.height)
      ..cubicTo(size.width * 0.2238571, size.height, 0, size.height * 0.7761429, 0, size.height * 0.5000000)
      ..cubicTo(0, size.height * 0.2238571, size.width * 0.2238571, 0, size.width * 0.5000000, 0)
      ..cubicTo(size.width * 0.7761429, 0, size.width, size.height * 0.2238571, size.width, size.height * 0.5000000)
      ..close()
      ..moveTo(size.width * 0.08500000, size.height * 0.5000000)
      ..cubicTo(size.width * 0.08500000, size.height * 0.7291986, size.width * 0.2708014, size.height * 0.9150000,
          size.width * 0.5000000, size.height * 0.9150000)
      ..cubicTo(size.width * 0.7291986, size.height * 0.9150000, size.width * 0.9150000, size.height * 0.7291986,
          size.width * 0.9150000, size.height * 0.5000000)
      ..cubicTo(size.width * 0.9150000, size.height * 0.2708014, size.width * 0.7291986, size.height * 0.08500000,
          size.width * 0.5000000, size.height * 0.08500000)
      ..cubicTo(size.width * 0.2708014, size.height * 0.08500000, size.width * 0.08500000, size.height * 0.2708014,
          size.width * 0.08500000, size.height * 0.5000000)
      ..close();

    final Paint paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
          Offset(size.width * -10.29307, size.height * 1.046056),
          Offset(size.width * 1.438800, size.height * 0.1051147),
          [AppColors.green2, const Color(0xff2D953B).withOpacity(0)],
          [0, 1]);

    canvas.drawPath(path_0, paint0Fill);

    final Paint paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.white;

    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.4285714, paint2Fill);

    final Path path_1 = Path()
      ..moveTo(size.width * 0.7096774, size.height * 0.4032258)
      ..lineTo(size.width * 0.4092742, size.height * 0.6612903)
      ..lineTo(size.width * 0.2580645, size.height * 0.5146629);

    final Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02857143
      ..color = AppColors.green1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path_1, paint1Stroke);

    final Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02857143
      ..color = AppColors.green1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.4285714, paint2Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
