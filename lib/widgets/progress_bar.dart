import 'package:flutter/material.dart';
import 'package:teloswallet/constants/app_colors.dart';

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
