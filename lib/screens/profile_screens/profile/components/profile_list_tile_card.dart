import 'package:flutter/material.dart';
import 'package:seeds/components/notification_badge.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class ProfileListTileCard extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  final bool hasNotification;

  const ProfileListTileCard({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.hasNotification = false,
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
        ),
        child: ListTile(
          leading: Icon(leadingIcon),
          title: Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.buttonLowEmphasis),
              const SizedBox(width: 10),
              if (hasNotification) const NotificationBadge() else const SizedBox.shrink()
            ],
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
