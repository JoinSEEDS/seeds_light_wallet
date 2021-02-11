import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';

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
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.jungle,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.settings_outlined, color: Colors.white),
                title: Text(
                  'Settings'.i18n,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.jungle,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.verified_user_outlined, color: Colors.white),
                title: Text(
                  'Security'.i18n,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 26.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.jungle,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.support, color: Colors.white),
                title: Text(
                  'Support'.i18n,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
