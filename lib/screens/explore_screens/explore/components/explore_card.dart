import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ExploreCard extends StatelessWidget {
  final String title;
  final Widget? icon;
  final bool iconUseCircleBackground;
  final Color? backgroundIconColor;
  final String? backgroundImage;
  final Gradient? gradient;
  final VoidCallback onTap;

  const ExploreCard({
    super.key,
    required this.title,
    required this.icon,
    this.iconUseCircleBackground = true,
    this.backgroundIconColor,
    this.backgroundImage,
    this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.darkGreen2,
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          gradient: gradient,
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            if (backgroundImage != null) Image.asset(backgroundImage!),
            if (title == context.loc.explorerSwapItemTitle)
              LayoutBuilder(builder: (context, constrains) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(defaultCardBorderRadius),
                      bottomLeft: Radius.circular(defaultCardBorderRadius)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/wallet/leaves_bttm_left.png', width: constrains.maxWidth * 0.5),
                      Image.asset('assets/images/wallet/leaves_bttm_right.png', width: constrains.maxWidth * 0.5),
                    ],
                  ),
                );
              }),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4.0),
                  if (icon != null && iconUseCircleBackground)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: const BoxDecoration(color: AppColors.lightGreen2, shape: BoxShape.circle),
                        child: Center(child: icon),
                      ),
                    ),
                  if (icon != null && !iconUseCircleBackground)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: backgroundIconColor != null
                                ? backgroundIconColor!.withOpacity(0.2)
                                : AppColors.lightGreen2,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(child: icon),
                      ),
                    ),
                  Flexible(
                      child: Text(title,
                          style: !iconUseCircleBackground
                              ? Theme.of(context).textTheme.buttonWhiteL.copyWith(fontSize: 18)
                              : Theme.of(context).textTheme.buttonWhiteL)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
