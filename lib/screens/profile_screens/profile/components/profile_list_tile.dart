import 'package:flutter/material.dart';
import 'package:seeds/components/shimmer_circle.dart';
import 'package:seeds/components/shimmer_rectangle.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/text_size_extension.dart';

class ProfileListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String trailing;
  final VoidCallback onTap;
  final bool showShimmer;

  const ProfileListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.showShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    final Text titleText = Text(title, style: Theme.of(context).textTheme.button);
    final Text trailingText = Text(trailing, style: Theme.of(context).textTheme.headline7LowEmphasis);
    return SizedBox(
      height: 60,
      child: showShimmer
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Row(
                children: [
                  const ShimmerCircle(28),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        ShimmerRectangle(size: titleText.textSize),
                        const Spacer(),
                        ShimmerRectangle(size: trailingText.textSize),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Row(children: [leading, const SizedBox(width: 20), Expanded(child: titleText), trailingText]),
              ),
            ),
    );
  }
}
