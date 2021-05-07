import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class ReceiveSelectionCard extends StatelessWidget {
  final String title;
  final Widget? icon;
  final GestureTapCallback? callback;

  const ReceiveSelectionCard({
    Key? key,
    required this.title,
    this.icon,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: callback,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.darkGreen2,
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            icon ?? const SizedBox.shrink(),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.button,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
