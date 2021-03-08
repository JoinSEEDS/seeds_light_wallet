import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

/// CARD LIST TILE
class CardListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String route;

  const CardListTile({
    Key key,
    @required this.leadingIcon,
    @required this.title,
    @required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: () => NavigationService.of(context).navigateTo(route),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.darkGreen2,
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        ),
        child: ListTile(
          leading: Icon(leadingIcon),
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          trailing: const Icon(Icons.arrow_forward_ios_sharp),
        ),
      ),
    );
  }
}
