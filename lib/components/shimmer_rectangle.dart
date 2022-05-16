import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRectangle extends StatelessWidget {
  final Size size;
  final double radius;

  const ShimmerRectangle({super.key, required this.size, this.radius = 4});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGreen2,
      highlightColor: AppColors.lightGreen2,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
        ),
      ),
    );
  }
}
