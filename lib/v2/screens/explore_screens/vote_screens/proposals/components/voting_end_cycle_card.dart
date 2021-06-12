import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/vote.i18n.dart';

class VotingCycleEndCard implements SliverPersistentHeaderDelegate {
  const VotingCycleEndCard();

  @override
  Widget build(BuildContext context, double shrinkOffSet, bool overLapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: AppColors.primary),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Voting cycle ends in'.i18n),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('TODO ', style: Theme.of(context).textTheme.headline5),
                            Text('days'.i18n, style: Theme.of(context).textTheme.subtitle3Opacity)
                          ],
                        ),
                        Row(
                          children: [
                            Text('TODO ', style: Theme.of(context).textTheme.headline5),
                            Text('hrs'.i18n, style: Theme.of(context).textTheme.subtitle3Opacity)
                          ],
                        ),
                        Row(
                          children: [
                            Text('TODO ', style: Theme.of(context).textTheme.headline5),
                            Text('mins'.i18n, style: Theme.of(context).textTheme.subtitle3Opacity)
                          ],
                        ),
                        Row(
                          children: [
                            Text('TODO ', style: Theme.of(context).textTheme.headline5),
                            Text('sec'.i18n, style: Theme.of(context).textTheme.subtitle3Opacity)
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 130;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => null;
}
