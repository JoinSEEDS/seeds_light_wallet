import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class ExploreInfoCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final String amount;
  final String amountLabel;
  final GestureTapCallback callback;
  final bool isErrorState;

  const ExploreInfoCard({
    Key key,
    @required this.title,
    this.icon,
    @required this.amount,
    @required this.amountLabel,
    @required this.callback,
    this.isErrorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.jungle,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.headline8)),
                icon != null ? icon : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 24),
            Text((isErrorState != null && isErrorState) ? "Error Loading Data" : amount, style: Theme.of(context).textTheme.headline8),
            SizedBox(height: 4),
            Text(amountLabel, style: Theme.of(context).textTheme.subtitle3),
          ],
        ),
      ),
    );
  }
}
