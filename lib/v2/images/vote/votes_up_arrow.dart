import 'package:flutter/rendering.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class VotesUpArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = AppColors.lightGreen3;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3285311, size.height * 0.4207500);
    path_1.lineTo(size.width * 0.4828536, size.height * 0.2575129);
    path_1.cubicTo(size.width * 0.4923214, size.height * 0.2474957, size.width * 0.5076786, size.height * 0.2474957,
        size.width * 0.5171464, size.height * 0.2575129);
    path_1.lineTo(size.width * 0.6714679, size.height * 0.4207500);
    path_1.cubicTo(size.width * 0.6809393, size.height * 0.4307679, size.width * 0.6809393, size.height * 0.4470107,
        size.width * 0.6714679, size.height * 0.4570250);
    path_1.cubicTo(size.width * 0.6620000, size.height * 0.4670429, size.width * 0.6466464, size.height * 0.4670429,
        size.width * 0.6371750, size.height * 0.4570250);
    path_1.lineTo(size.width * 0.5242500, size.height * 0.3375761);
    path_1.lineTo(size.width * 0.5242500, size.height * 0.7243500);
    path_1.cubicTo(size.width * 0.5242500, size.height * 0.7385143, size.width * 0.5133929, size.height * 0.7500000,
        size.width * 0.5000000, size.height * 0.7500000);
    path_1.cubicTo(size.width * 0.4866071, size.height * 0.7500000, size.width * 0.4757500, size.height * 0.7385143,
        size.width * 0.4757500, size.height * 0.7243500);
    path_1.lineTo(size.width * 0.4757500, size.height * 0.3375761);
    path_1.lineTo(size.width * 0.3628250, size.height * 0.4570250);
    path_1.cubicTo(size.width * 0.3533550, size.height * 0.4670429, size.width * 0.3380011, size.height * 0.4670429,
        size.width * 0.3285311, size.height * 0.4570250);
    path_1.cubicTo(size.width * 0.3190611, size.height * 0.4470107, size.width * 0.3190611, size.height * 0.4307679,
        size.width * 0.3285311, size.height * 0.4207500);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = AppColors.green3;
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
