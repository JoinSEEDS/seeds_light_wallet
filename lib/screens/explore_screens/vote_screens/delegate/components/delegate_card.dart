import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/images/vote/category_label.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/components/delegate_row.dart';

class DelegateCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool activeDelegate;
  final VoidCallback onTapRemove;
  final DelegateModel? delegate;

  const DelegateCard(
      {Key? key, required this.onTap, required this.activeDelegate, required this.onTapRemove, this.delegate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding, vertical: 20),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.darkGreen2,
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomPaint(
                  size: const Size(100, 40),
                  painter: const CategoryLabel(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      'Campaign',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size(100, 40),
                  painter: const CategoryLabel(color: AppColors.tagBlue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      'Alliance',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size(100, 40),
                  painter: const CategoryLabel(color: AppColors.subtitle),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      'Referendum',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text("Trust Tokens Used/Available"), const Text("Todo / 99")],
              ),
            ),
            const SizedBox(height: 30.0),
            if (activeDelegate)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                  child: DelegateRow(
                    account: delegate!.delegatee,
                    nickname: delegate!.delegatee,
                    onTapRemove: onTapRemove,
                  ))
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                child: TextButton(
                  onPressed: onTap,
                  child: Row(
                    children: [
                      Text(
                        "Delegate Trust",
                        style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.green2,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
