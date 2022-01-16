import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class ContributionDetailSubtitle extends StatelessWidget {
  final String title;

  const ContributionDetailSubtitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(8.0)),
      child: Center(child: Text(title)),
    );
  }
}
