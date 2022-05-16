import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGreen2,
      highlightColor: AppColors.lightGreen2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(width: size, height: size, color: AppColors.primary),
      ),
    );
  }
}
