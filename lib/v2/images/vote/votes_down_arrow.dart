import 'package:flutter/rendering.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class VotesDownArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.lightGreen3;

    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint);

    Path path1 = Path()
      ..moveTo(size.width * 0.6800400, size.height * 0.5792500)
      ..lineTo(size.width * 0.5180050, size.height * 0.7424850)
      ..cubicTo(size.width * 0.5080600, size.height * 0.7525050, size.width * 0.4919390, size.height * 0.7525050,
          size.width * 0.4819955, size.height * 0.7424850)
      ..lineTo(size.width * 0.3199575, size.height * 0.5792500)
      ..cubicTo(size.width * 0.3100140, size.height * 0.5692300, size.width * 0.3100140, size.height * 0.5529900,
          size.width * 0.3199575, size.height * 0.5429750)
      ..cubicTo(size.width * 0.3299010, size.height * 0.5329550, size.width * 0.3460225, size.height * 0.5329550,
          size.width * 0.3559660, size.height * 0.5429750)
      ..lineTo(size.width * 0.4745380, size.height * 0.6624250)
      ..lineTo(size.width * 0.4745380, size.height * 0.2756505)
      ..cubicTo(size.width * 0.4745380, size.height * 0.2614840, size.width * 0.4859380, size.height * 0.2500000,
          size.width * 0.5000000, size.height * 0.2500000)
      ..cubicTo(size.width * 0.5140600, size.height * 0.2500000, size.width * 0.5254600, size.height * 0.2614840,
          size.width * 0.5254600, size.height * 0.2756505)
      ..lineTo(size.width * 0.5254600, size.height * 0.6624250)
      ..lineTo(size.width * 0.6440350, size.height * 0.5429750)
      ..cubicTo(size.width * 0.6539750, size.height * 0.5329550, size.width * 0.6701000, size.height * 0.5329550,
          size.width * 0.6800400, size.height * 0.5429750)
      ..cubicTo(size.width * 0.6899850, size.height * 0.5529900, size.width * 0.6899850, size.height * 0.5692300,
          size.width * 0.6800400, size.height * 0.5792500)
      ..close();

    Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.lightGreen6;

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
