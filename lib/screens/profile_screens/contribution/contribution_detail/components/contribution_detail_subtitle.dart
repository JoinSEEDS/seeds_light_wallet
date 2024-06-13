import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class ContributionDetailSubtitle extends StatelessWidget {
  final String title;

  const ContributionDetailSubtitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
      padding: const EdgeInsets.all(horizontalEdgePadding),
      decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(8.0)),
      child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
