import 'package:flutter/rendering.dart';

class VotesAbstainSlash extends CustomPainter {
  const VotesAbstainSlash();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xffEAEDDA).withOpacity(1.0);

    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint);

    Path path = Path()
      ..moveTo(size.width * 0.6461538, size.height * 0.3538462)
      ..lineTo(size.width * 0.3384615, size.height * 0.6615385);

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03076923
      ..color = const Color(0xff87928B).withOpacity(1.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paintStroke);

    Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
