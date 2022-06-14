import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/images/vote/category_label.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/components/delegate_row.dart';

class DelegateCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool activeDelegate;
  final VoidCallback onTapRemove;
  final ProfileModel? delegate;

  const DelegateCard({
    super.key,
    required this.onTap,
    required this.activeDelegate,
    required this.onTapRemove,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.darkGreen2,
        borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CustomPaint(
            size: const Size(100, 40),
            painter: const CategoryLabel(color: AppColors.lightGreen3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Delegate',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          if (activeDelegate)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
              child: DelegateRow(
                  account: delegate?.account ?? '',
                  nickname: delegate?.nickname ?? '',
                  avatarImage: delegate?.image,
                  onTapRemove: onTapRemove),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
              child: TextButton(
                onPressed: onTap,
                child: Row(
                  children: [
                    Text(
                      "Choose Delegate",
                      style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_outlined, color: AppColors.green2, size: 16)
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
