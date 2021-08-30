import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/notification_badge.dart';
import 'package:seeds/components/shimmer_rectangle.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

class ProfileListTileCard extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  final bool hasNotification;

  const ProfileListTileCard({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.hasNotification = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return state.showShimmer
            ? const ShimmerRectangle(size: Size(328, 56), radius: defaultCardBorderRadius)
            : InkWell(
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
      },
    );
  }
}
