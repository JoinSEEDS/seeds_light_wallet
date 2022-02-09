import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class SeedsSymbol extends CustomPainter {
  const SeedsSymbol();

  @override
  void paint(Canvas canvas, Size size) {
    final Path path0 = Path()
      ..moveTo(size.width * 0.6851140, size.height * 0.5000043)
      ..lineTo(size.width * 0.9333090, size.height * 0.4427826)
      ..lineTo(size.width * 0.9333090, size.height * 0.4855478)
      ..lineTo(size.width * 0.7136940, size.height * 0.5361435)
      ..cubicTo(size.width * 0.8174850, size.height * 0.5758957, size.width * 0.9287960, size.height * 0.6391391,
          size.width * 0.9287960, size.height * 0.7264739)
      ..cubicTo(size.width * 0.9287960, size.height * 0.8885000, size.width * 0.5512390, size.height * 0.9662000,
          size.width * 0.5346930, size.height * 0.9692130)
      ..cubicTo(size.width * 0.5286760, size.height * 0.9704174, size.width * 0.5211550, size.height * 0.9710174,
          size.width * 0.5136340, size.height * 0.9710174)
      ..cubicTo(size.width * 0.5061130, size.height * 0.9710174, size.width * 0.5000960, size.height * 0.9704174,
          size.width * 0.4925750, size.height * 0.9692130)
      ..cubicTo(size.width * 0.4775330, size.height * 0.9662000, size.width * 0.1676650, size.height * 0.9023522,
          size.width * 0.1090010, size.height * 0.7698435)
      ..lineTo(size.width * 0.1962450, size.height * 0.7499652)
      ..cubicTo(size.width * 0.2263290, size.height * 0.8541696, size.width * 0.4444400, size.height * 0.9144000,
          size.width * 0.5136340, size.height * 0.9312652)
      ..cubicTo(size.width * 0.5873400, size.height * 0.9131957, size.width * 0.8355350, size.height * 0.8451348,
          size.width * 0.8355350, size.height * 0.7264739)
      ..cubicTo(size.width * 0.8355350, size.height * 0.6469696, size.width * 0.7242230, size.height * 0.5897478,
          size.width * 0.6294580, size.height * 0.5554174)
      ..lineTo(size.width * 0.1029840, size.height * 0.6770870)
      ..lineTo(size.width * 0.1029840, size.height * 0.6343217)
      ..lineTo(size.width * 0.4444400, size.height * 0.5554174)
      ..lineTo(size.width * 0.6851140, size.height * 0.5000043)
      ..close()
      ..moveTo(size.width * 0.4098430, size.height * 0.4488043)
      ..cubicTo(size.width * 0.3120690, size.height * 0.4150765, size.width * 0.1917330, size.height * 0.3566513,
          size.width * 0.1917330, size.height * 0.2741335)
      ..cubicTo(size.width * 0.1917330, size.height * 0.1554765, size.width * 0.4399270, size.height * 0.08681174,
          size.width * 0.5136340, size.height * 0.06874217)
      ..cubicTo(size.width * 0.5843320, size.height * 0.08560696, size.width * 0.8099640, size.height * 0.1482487,
          size.width * 0.8325270, size.height * 0.2560639)
      ..lineTo(size.width * 0.9197710, size.height * 0.2355848)
      ..cubicTo(size.width * 0.8686280, size.height * 0.09946043, size.width * 0.5497350, size.height * 0.03380761,
          size.width * 0.5346930, size.height * 0.03079600)
      ..cubicTo(size.width * 0.5211550, size.height * 0.02838674, size.width * 0.5061130, size.height * 0.02838674,
          size.width * 0.4925750, size.height * 0.03079600)
      ..cubicTo(size.width * 0.4760290, size.height * 0.03440991, size.width * 0.09997560, size.height * 0.1115070,
          size.width * 0.09997560, size.height * 0.2741335)
      ..cubicTo(size.width * 0.09997560, size.height * 0.3650839, size.width * 0.2188080, size.height * 0.4295322,
          size.width * 0.3256070, size.height * 0.4686826)
      ..lineTo(size.width * 0.1014800, size.height * 0.5204826)
      ..lineTo(size.width * 0.1014800, size.height * 0.5632478)
      ..lineTo(size.width * 0.3647170, size.height * 0.5024130)
      ..lineTo(size.width * 0.5587600, size.height * 0.4578391)
      ..lineTo(size.width * 0.9333090, size.height * 0.3711070)
      ..lineTo(size.width * 0.9333090, size.height * 0.3283422)
      ..lineTo(size.width * 0.4098430, size.height * 0.4488043)
      ..close();

    final Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05000000
      ..color = AppColors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path0, paint0Stroke);

    final Paint paint0 = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.white;

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
