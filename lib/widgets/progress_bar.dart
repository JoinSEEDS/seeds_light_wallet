// @dart=2.9

import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearProgressIndicator(
        backgroundColor: AppColors.green,
      ),
    );
  }
}
