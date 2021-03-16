import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/card_list_tile.dart';

/// PROFILE BOTTOM
class ProfileBottom extends StatelessWidget {
  const ProfileBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.lightGreen2,
              borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 24.0),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(defaultCardBorderRadius),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/lotus.svg",
                            color: AppColors.canopy,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'You are on the way from'.i18n,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Resident'.i18n,
                                    style: Theme.of(context).textTheme.headline6.copyWith(color: AppColors.canopy),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'to'.i18n,
                                          style:
                                              Theme.of(context).textTheme.headline7.copyWith(color: AppColors.primary),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Citizen'.i18n,
                                      style: Theme.of(context).textTheme.headline6.copyWith(color: AppColors.canopy),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: AppColors.green1,
                                  padding: const EdgeInsets.all(8.0),
                                  onPressed: () => NavigationService.of(context).navigateTo(Routes.citizenship),
                                  child: Text(
                                    'View your progress'.i18n,
                                    style: Theme.of(context).textTheme.subtitle3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          CardListTile(leadingIcon: Icons.verified_user_outlined, title: 'Security'.i18n, route: Routes.security),
          const SizedBox(height: 8.0),
          CardListTile(leadingIcon: Icons.support, title: 'Support'.i18n, route: Routes.support),
          const SizedBox(height: 26.0),
        ],
      ),
    );
  }
}
