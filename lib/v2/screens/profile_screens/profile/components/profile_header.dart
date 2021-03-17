import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/components/profile_avatar.dart';

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
                      ProfileAvatar(
                        size: 100,
                        image: state.profile.image,
                        nickname: state.profile.nickname,
                        account: state.profile.account,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              state.profile?.account ?? '',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                var res = await NavigationService.of(context).navigateTo(
                                  Routes.editName,
                                  state.profile.nickname,
                                );
                                if (res != null) {
                                  BlocProvider.of<ProfileBloc>(context).add(OnNameChanged(name: res as String));
                                }
                              },
                            ),
                          ],
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
                            right: BorderSide(color: AppColors.lightGreen2, width: 2),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            NavigationService.of(context).navigateTo(Routes.contribution, state.profile);
                          },
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
                                  '${state.profile?.reputation ?? '00'}/99',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline7LowEmphasis,
                                ),
                              ),
                            ],
                          ),
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
