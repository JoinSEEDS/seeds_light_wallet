import 'package:flutter/material.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class ExploreLinkCard extends StatelessWidget {
  final String backgroundImage;
  final GestureTapCallback onTap;

  const ExploreLinkCard({
    Key? key,
    required this.backgroundImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
