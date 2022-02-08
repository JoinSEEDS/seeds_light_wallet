import 'package:flutter/rendering.dart';
import 'package:seeds/design/app_colors.dart';

class DoubleSidedArrow extends CustomPainter {
  const DoubleSidedArrow();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.lightGreen3;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint0Fill);

    final Path path_1 = Path()
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

    final Paint paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.green3;

    canvas.drawPath(path_1, paint1Fill);

    final Path path_2 = Path()
      ..moveTo(size.width * 0.6714679, size.height * 0.5792500)
      ..lineTo(size.width * 0.5171464, size.height * 0.7424857)
      ..cubicTo(size.width * 0.5076786, size.height * 0.7525036, size.width * 0.4923214, size.height * 0.7525036,
          size.width * 0.4828536, size.height * 0.7424857)
      ..lineTo(size.width * 0.3285311, size.height * 0.5792500)
      ..cubicTo(size.width * 0.3190611, size.height * 0.5692321, size.width * 0.3190611, size.height * 0.5529893,
          size.width * 0.3285311, size.height * 0.5429750)
      ..cubicTo(size.width * 0.3380011, size.height * 0.5329571, size.width * 0.3533550, size.height * 0.5329571,
          size.width * 0.3628250, size.height * 0.5429750)
      ..lineTo(size.width * 0.4757500, size.height * 0.6624250)
      ..lineTo(size.width * 0.4757500, size.height * 0.2756504)
      ..cubicTo(size.width * 0.4757500, size.height * 0.2614839, size.width * 0.4866071, size.height * 0.2500000,
          size.width * 0.5000000, size.height * 0.2500000)
      ..cubicTo(size.width * 0.5133929, size.height * 0.2500000, size.width * 0.5242500, size.height * 0.2614839,
          size.width * 0.5242500, size.height * 0.2756504)
      ..lineTo(size.width * 0.5242500, size.height * 0.6624250)
      ..lineTo(size.width * 0.6371750, size.height * 0.5429750)
      ..cubicTo(size.width * 0.6466464, size.height * 0.5329571, size.width * 0.6620000, size.height * 0.5329571,
          size.width * 0.6714679, size.height * 0.5429750)
      ..cubicTo(size.width * 0.6809393, size.height * 0.5529893, size.width * 0.6809393, size.height * 0.5692321,
          size.width * 0.6714679, size.height * 0.5792500)
      ..close();

    final Paint paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.green3;

    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
