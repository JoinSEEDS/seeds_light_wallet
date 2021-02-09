import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';

const List<String> skillsAndInterest = ['Weaver', 'Facilitador', 'SharingXP'];

/// PROFILE SCREEN
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: ListView(
        children: <Widget>[
          const _ProfileHeader(),
          const Divider(color: AppColors.jungle, thickness: 2),
          const _ProfileMiddle(),
          const Divider(color: AppColors.jungle, thickness: 2),
          const _ProfileBottom(),
        ],
      ),
    );
  }
}

/// PROFILE HEADER
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      child:
                          //  (_profileImage != null)
                          //     ? Image.file(
                          //         _profileImage,
                          //         fit: BoxFit.cover,
                          //       )
                          //     :
                          CachedNetworkImage(
                        imageUrl: '',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Container(
                            color: AppColors.getColorByString(''),
                            child: Center(
                              child: Text(
                                ('Raul' != null)
                                    ? 'Raul'?.substring(0, 2)?.toUpperCase()
                                    : '?',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Raul Urtecho',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Resident',
                      style: Theme.of(context).textTheme.headline7LowEmphasis,
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.jungle, width: 2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Contribution Score'.i18n,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '83/100',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline7LowEmphasis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Badges Earned'.i18n,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 36,
                                color: Colors.transparent,
                              ),
                              Icon(
                                Icons.circle,
                                size: 36,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                          Positioned(
                            width: 36,
                            child: Icon(
                              Icons.circle_notifications,
                              size: 36,
                              color: Colors.blue,
                            ),
                          ),
                          Positioned(
                            width: 72,
                            child: Icon(
                              Icons.account_circle_rounded,
                              size: 36,
                              color: Colors.orange,
                            ),
                          ),
                          Positioned(
                            width: 108,
                            child: Icon(
                              Icons.add_circle,
                              size: 36,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// PROFILE MIDDLE
class _ProfileMiddle extends StatelessWidget {
  const _ProfileMiddle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading:
                Icon(Icons.location_on_outlined, color: AppColors.springGreen),
            title: Text(
              'Bioregion'.i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
            trailing: Text(
              'Bali',
              style: Theme.of(context).textTheme.subtitle1HighEmphasis,
            ),
            onTap: () {
              //_chooseCurrencyBottomSheet
            },
          ),
          Divider(color: AppColors.jungle),
          ListTile(
            leading:
                Icon(Icons.attach_money_sharp, color: AppColors.springGreen),
            title: Text(
              'Currency'.i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
            trailing: Text(
              'USD',
              style: Theme.of(context).textTheme.subtitle1HighEmphasis,
            ),
            onTap: () {
              //_chooseCurrencyBottomSheet
            },
          ),
          Divider(color: AppColors.jungle),
          ListTile(
            leading: Icon(
              Icons.favorite_border,
              color: AppColors.springGreen,
            ),
            title: Text(
              'Skills & Interest'.i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8, // gap between adjacent chips
              runSpacing: 0, // gap between lines
              children: skillsAndInterest
                  .map((i) => Chip(
                        backgroundColor: AppColors.jungle,
                        label: Text(
                          i,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// PROFILE BOTTOM
class _ProfileBottom extends StatelessWidget {
  const _ProfileBottom({Key key}) : super(key: key);

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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2HighEmphasis,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:
                              // If the text is longer than the condition use 2 rows instead of one
                              ('Resident'.i18n.length > 8 &&
                                      'Citizen'.i18n.length > 7)
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Resident'.i18n,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: AppColors.canopy),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
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
                                                        .copyWith(
                                                            color: AppColors
                                                                .primary),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Citizen'.i18n,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        color:
                                                            AppColors.canopy),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  color: AppColors.canopy),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
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
                                                    .copyWith(
                                                        color:
                                                            AppColors.primary),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'Citizen'.i18n,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color: AppColors.canopy),
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
                trailing:
                    Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
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
                leading:
                    Icon(Icons.verified_user_outlined, color: Colors.white),
                title: Text(
                  'Security'.i18n,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing:
                    Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
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
                trailing:
                    Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
