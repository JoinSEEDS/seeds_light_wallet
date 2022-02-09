import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class DividerJungle extends StatelessWidget {
  final double thickness;
  final double height;

  const DividerJungle({Key? key, this.thickness = 1, this.height = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(color: AppColors.lightGreen2, thickness: thickness, height: height);
  }
}
