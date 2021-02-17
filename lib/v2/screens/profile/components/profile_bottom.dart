import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';

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
            decoration: BoxDecoration(
              color: AppColors.jungle,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/lotus.svg",
                      alignment: Alignment.centerLeft,
                      color: AppColors.canopy,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'You are on the way from'.i18n,
                              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:
                              // If the text is longer than the condition use 2 rows instead of one
                              ('Resident'.i18n.length > 8 && 'Citizen'.i18n.length > 7)
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Resident'.i18n,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(color: AppColors.canopy),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'to'.i18n,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(color: AppColors.primary),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Citizen'.i18n,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(color: AppColors.canopy),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          'Resident'.i18n,
                                          style:
                                              Theme.of(context).textTheme.headline6.copyWith(color: AppColors.canopy),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'to'.i18n,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(color: AppColors.primary),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'Citizen'.i18n,
                                            style:
                                                Theme.of(context).textTheme.headline6.copyWith(color: AppColors.canopy),
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
                              color: AppColors.springGreen,
                              padding: EdgeInsets.all(8.0),
                              onPressed: () {},
                              child: Text(
                                'View your progress'.i18n,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          _CardListTile(leadingIcon: Icons.settings_outlined, title: 'Settings'.i18n, route: Routes.settings),
          const SizedBox(height: 8.0),
          _CardListTile(leadingIcon: Icons.verified_user_outlined, title: 'Security'.i18n, route: ''),
          const SizedBox(height: 8.0),
          _CardListTile(leadingIcon: Icons.support, title: 'Support'.i18n, route: ''),
          const SizedBox(height: 26.0),
        ],
      ),
    );
  }
}

/// CARD LIST TILE
class _CardListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String route;

  const _CardListTile({
    Key key,
    @required this.leadingIcon,
    @required this.title,
    @required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () => NavigationService.of(context).navigateTo(route),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.greenfield,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Icon(leadingIcon, color: Colors.white),
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
        ),
      ),
    );
  }
}
