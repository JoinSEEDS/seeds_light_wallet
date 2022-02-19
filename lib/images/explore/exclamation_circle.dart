import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class ExclamationCircle extends CustomPainter {
  const ExclamationCircle();

  @override
  void paint(Canvas canvas, Size size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, size.height * 0.9375000);
    path_0.cubicTo(size.width * 0.3839682, size.height * 0.9375000, size.width * 0.2726886, size.height * 0.8914068,
        size.width * 0.1906407, size.height * 0.8093591);
    path_0.cubicTo(size.width * 0.1085936, size.height * 0.7273114, size.width * 0.06250000, size.height * 0.6160318,
        size.width * 0.06250000, size.height * 0.5000000);
    path_0.cubicTo(size.width * 0.06250000, size.height * 0.3839682, size.width * 0.1085936, size.height * 0.2726886,
        size.width * 0.1906407, size.height * 0.1906407);
    path_0.cubicTo(size.width * 0.2726886, size.height * 0.1085936, size.width * 0.3839682, size.height * 0.06250000,
        size.width * 0.5000000, size.height * 0.06250000);
    path_0.cubicTo(size.width * 0.6160318, size.height * 0.06250000, size.width * 0.7273114, size.height * 0.1085936,
        size.width * 0.8093591, size.height * 0.1906407);
    path_0.cubicTo(size.width * 0.8914068, size.height * 0.2726886, size.width * 0.9375000, size.height * 0.3839682,
        size.width * 0.9375000, size.height * 0.5000000);
    path_0.cubicTo(size.width * 0.9375000, size.height * 0.6160318, size.width * 0.8914068, size.height * 0.7273114,
        size.width * 0.8093591, size.height * 0.8093591);
    path_0.cubicTo(size.width * 0.7273114, size.height * 0.8914068, size.width * 0.6160318, size.height * 0.9375000,
        size.width * 0.5000000, size.height * 0.9375000);
    path_0.close();
    path_0.moveTo(size.width * 0.5000000, size.height);
    path_0.cubicTo(size.width * 0.6326091, size.height, size.width * 0.7597841, size.height * 0.9473227,
        size.width * 0.8535545, size.height * 0.8535545);
    path_0.cubicTo(size.width * 0.9473227, size.height * 0.7597841, size.width, size.height * 0.6326091, size.width,
        size.height * 0.5000000);
    path_0.cubicTo(size.width, size.height * 0.3673909, size.width * 0.9473227, size.height * 0.2402159,
        size.width * 0.8535545, size.height * 0.1464466);
    path_0.cubicTo(
        size.width * 0.7597841, size.height * 0.05267841, size.width * 0.6326091, 0, size.width * 0.5000000, 0);
    path_0.cubicTo(size.width * 0.3673909, 0, size.width * 0.2402159, size.height * 0.05267841, size.width * 0.1464466,
        size.height * 0.1464466);
    path_0.cubicTo(
        size.width * 0.05267841, size.height * 0.2402159, 0, size.height * 0.3673909, 0, size.height * 0.5000000);
    path_0.cubicTo(0, size.height * 0.6326091, size.width * 0.05267841, size.height * 0.7597841, size.width * 0.1464466,
        size.height * 0.8535545);
    path_0.cubicTo(size.width * 0.2402159, size.height * 0.9473227, size.width * 0.3673909, size.height,
        size.width * 0.5000000, size.height);
    path_0.close();

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = AppColors.white;
    canvas.drawPath(path_0, paint0Fill);

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.4376250, size.height * 0.6875000);
    path_1.cubicTo(size.width * 0.4376250, size.height * 0.6792909, size.width * 0.4392409, size.height * 0.6711636,
        size.width * 0.4423818, size.height * 0.6635818);
    path_1.cubicTo(size.width * 0.4455227, size.height * 0.6559977, size.width * 0.4501273, size.height * 0.6491091,
        size.width * 0.4559318, size.height * 0.6433045);
    path_1.cubicTo(size.width * 0.4617341, size.height * 0.6375023, size.width * 0.4686250, size.height * 0.6328977,
        size.width * 0.4762068, size.height * 0.6297568);
    path_1.cubicTo(size.width * 0.4837909, size.height * 0.6266159, size.width * 0.4919182, size.height * 0.6250000,
        size.width * 0.5001250, size.height * 0.6250000);
    path_1.cubicTo(size.width * 0.5083318, size.height * 0.6250000, size.width * 0.5164591, size.height * 0.6266159,
        size.width * 0.5240432, size.height * 0.6297568);
    path_1.cubicTo(size.width * 0.5316250, size.height * 0.6328977, size.width * 0.5385159, size.height * 0.6375023,
        size.width * 0.5443182, size.height * 0.6433045);
    path_1.cubicTo(size.width * 0.5501227, size.height * 0.6491091, size.width * 0.5547273, size.height * 0.6559977,
        size.width * 0.5578682, size.height * 0.6635818);
    path_1.cubicTo(size.width * 0.5610091, size.height * 0.6711636, size.width * 0.5626250, size.height * 0.6792909,
        size.width * 0.5626250, size.height * 0.6875000);
    path_1.cubicTo(size.width * 0.5626250, size.height * 0.7040750, size.width * 0.5560409, size.height * 0.7199727,
        size.width * 0.5443182, size.height * 0.7316932);
    path_1.cubicTo(size.width * 0.5325977, size.height * 0.7434136, size.width * 0.5167000, size.height * 0.7500000,
        size.width * 0.5001250, size.height * 0.7500000);
    path_1.cubicTo(size.width * 0.4835477, size.height * 0.7500000, size.width * 0.4676523, size.height * 0.7434136,
        size.width * 0.4559318, size.height * 0.7316932);
    path_1.cubicTo(size.width * 0.4442091, size.height * 0.7199727, size.width * 0.4376250, size.height * 0.7040750,
        size.width * 0.4376250, size.height * 0.6875000);
    path_1.close();
    path_1.moveTo(size.width * 0.4437500, size.height * 0.3121864);
    path_1.cubicTo(size.width * 0.4429182, size.height * 0.3043023, size.width * 0.4437523, size.height * 0.2963295,
        size.width * 0.4462000, size.height * 0.2887886);
    path_1.cubicTo(size.width * 0.4486477, size.height * 0.2812477, size.width * 0.4526523, size.height * 0.2743045,
        size.width * 0.4579568, size.height * 0.2684114);
    path_1.cubicTo(size.width * 0.4632614, size.height * 0.2625182, size.width * 0.4697455, size.height * 0.2578045,
        size.width * 0.4769886, size.height * 0.2545795);
    path_1.cubicTo(size.width * 0.4842318, size.height * 0.2513545, size.width * 0.4920705, size.height * 0.2496864,
        size.width * 0.5000000, size.height * 0.2496864);
    path_1.cubicTo(size.width * 0.5079295, size.height * 0.2496864, size.width * 0.5157682, size.height * 0.2513545,
        size.width * 0.5230114, size.height * 0.2545795);
    path_1.cubicTo(size.width * 0.5302545, size.height * 0.2578045, size.width * 0.5367386, size.height * 0.2625182,
        size.width * 0.5420432, size.height * 0.2684114);
    path_1.cubicTo(size.width * 0.5473455, size.height * 0.2743045, size.width * 0.5513523, size.height * 0.2812477,
        size.width * 0.5538000, size.height * 0.2887886);
    path_1.cubicTo(size.width * 0.5562477, size.height * 0.2963295, size.width * 0.5570818, size.height * 0.3043023,
        size.width * 0.5562500, size.height * 0.3121864);
    path_1.lineTo(size.width * 0.5343750, size.height * 0.5313750);
    path_1.cubicTo(size.width * 0.5336409, size.height * 0.5399841, size.width * 0.5297000, size.height * 0.5480068,
        size.width * 0.5233341, size.height * 0.5538523);
    path_1.cubicTo(size.width * 0.5169682, size.height * 0.5596955, size.width * 0.5086409, size.height * 0.5629409,
        size.width * 0.5000000, size.height * 0.5629409);
    path_1.cubicTo(size.width * 0.4913568, size.height * 0.5629409, size.width * 0.4830295, size.height * 0.5596955,
        size.width * 0.4766659, size.height * 0.5538523);
    path_1.cubicTo(size.width * 0.4703000, size.height * 0.5480068, size.width * 0.4663591, size.height * 0.5399841,
        size.width * 0.4656250, size.height * 0.5313750);
    path_1.lineTo(size.width * 0.4437500, size.height * 0.3121864);
    path_1.close();

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = AppColors.white;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
