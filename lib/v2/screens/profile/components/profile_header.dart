import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/v2/screens/profile/interactor/profile_bloc.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/profile_state.dart';

/// PROFILE HEADER
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
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
                          child: state.profile?.image == null
                              ? SizedBox.shrink()
                              : CachedNetworkImage(
                                  imageUrl: state.profile?.image ?? '',
                                  fit: BoxFit.cover,
                                  // Show a nice loading as placeholder
                                  // placeholder: (_, url) =>
                                  //     Image.asset('assets/images/loading_image_placeholder.gif', fit: BoxFit.cover),
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      color: AppColors.getColorByString(state.profile?.nickname ?? ''),
                                      child: Center(
                                        child: Text(
                                          (state.profile?.nickname != null)
                                              ? state.profile?.nickname?.substring(0, 2)?.toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                          state.profile?.account ?? '',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          state.profile?.status ?? '',
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
                        decoration: const BoxDecoration(
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
                                '${state.profile?.reputation ?? '00'}/100',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline7LowEmphasis,
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
                                  const Icon(
                                    Icons.circle,
                                    size: 36,
                                    color: Colors.transparent,
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    size: 36,
                                    color: Colors.transparent,
                                  ),
                                ],
                              ),
                              const Positioned(
                                width: 36,
                                child: Icon(
                                  Icons.circle_notifications,
                                  size: 36,
                                  color: Colors.blue,
                                ),
                              ),
                              const Positioned(
                                width: 72,
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  size: 36,
                                  color: Colors.orange,
                                ),
                              ),
                              const Positioned(
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
      },
    );
  }
}
