import 'package:flutter/rendering.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class ProposalCategory extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = AppColors.orangeYellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width - 1, size.height);
    path_0.lineTo(size.width, size.height - 1);
    path_0.lineTo(size.width - 10, size.height - 11);
    path_0.lineTo(size.width, 1);
    path_0.lineTo(size.width - 1, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
