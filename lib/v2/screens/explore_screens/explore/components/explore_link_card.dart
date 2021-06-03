import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class ExploreLinkCard extends StatelessWidget {
  final String title;
  final String logoImage;
  final String backgroundImage;
  final Gradient? gradient;
  final GestureTapCallback onTap;

  const ExploreLinkCard({
    Key? key,
    required this.title,
    required this.logoImage,
    required this.backgroundImage,
    this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          gradient: gradient,
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
            image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.fill),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(logoImage),
                const SizedBox(height: 10.0),
                Text(title, style: Theme.of(context).textTheme.headline7LowEmphasis)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
