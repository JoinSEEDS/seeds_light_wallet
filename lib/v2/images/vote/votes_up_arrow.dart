import 'package:flutter/rendering.dart';

class VotesUpArrow extends CustomPainter {
  final Color arrowColor;
  final Color circleColor;

  const VotesUpArrow({required this.arrowColor, required this.circleColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = circleColor;

    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint);

    Path path1 = Path()
      ..moveTo(size.width * 0.3285311, size.height * 0.4207500)
      ..lineTo(size.width * 0.4828536, size.height * 0.2575129)
      ..cubicTo(size.width * 0.4923214, size.height * 0.2474957, size.width * 0.5076786, size.height * 0.2474957,
          size.width * 0.5171464, size.height * 0.2575129)
      ..lineTo(size.width * 0.6714679, size.height * 0.4207500)
      ..cubicTo(size.width * 0.6809393, size.height * 0.4307679, size.width * 0.6809393, size.height * 0.4470107,
          size.width * 0.6714679, size.height * 0.4570250)
      ..cubicTo(size.width * 0.6620000, size.height * 0.4670429, size.width * 0.6466464, size.height * 0.4670429,
          size.width * 0.6371750, size.height * 0.4570250)
      ..lineTo(size.width * 0.5242500, size.height * 0.3375761)
      ..lineTo(size.width * 0.5242500, size.height * 0.7243500)
      ..cubicTo(size.width * 0.5242500, size.height * 0.7385143, size.width * 0.5133929, size.height * 0.7500000,
          size.width * 0.5000000, size.height * 0.7500000)
      ..cubicTo(size.width * 0.4866071, size.height * 0.7500000, size.width * 0.4757500, size.height * 0.7385143,
          size.width * 0.4757500, size.height * 0.7243500)
      ..lineTo(size.width * 0.4757500, size.height * 0.3375761)
      ..lineTo(size.width * 0.3628250, size.height * 0.4570250)
      ..cubicTo(size.width * 0.3533550, size.height * 0.4670429, size.width * 0.3380011, size.height * 0.4670429,
          size.width * 0.3285311, size.height * 0.4570250)
      ..cubicTo(size.width * 0.3190611, size.height * 0.4470107, size.width * 0.3190611, size.height * 0.4307679,
          size.width * 0.3285311, size.height * 0.4207500)
      ..close();

    Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..color = arrowColor;

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
