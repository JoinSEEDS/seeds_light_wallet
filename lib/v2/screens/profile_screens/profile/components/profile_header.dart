import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/shimmer_circle.dart';
import 'package:seeds/v2/components/shimmer_rectangle.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/edit_profile_pic_bottom_sheet/edit_profile_pic_bottom_sheet.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/components/profile_avatar.dart';

/// PROFILE HEADER
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

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
                      InkWell(
                        onTap: () async {
                          final file = await showModalBottomSheet(
                            context: context,
                            builder: (context) => const EditProfilePicBottomSheet(),
                          );
                          if (file != null) {
                            BlocProvider.of<ProfileBloc>(context).add(OnUpdateProfileImage(file as File));
                          }
                        },
                        child: state.pageState == PageState.loading || state.pageState == PageState.initial
                            ? const ShimmerCircle(100)
                            : ProfileAvatar(
                                size: 100,
                                image: state.profile!.image,
                                nickname: state.profile!.nickname,
                                account: state.profile!.account,
                              ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: state.pageState == PageState.loading || state.pageState == PageState.initial
                                    ? const ShimmerRectangle(size: Size(154, 30))
                                    : Text(
                                        state.profile?.nickname ?? '',
                                        style: Theme.of(context).textTheme.button1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () async {
                                  var newName =
                                      await NavigationService.of(context).navigateTo(Routes.editName, state.profile);
                                  if (newName != null) {
                                    BlocProvider.of<ProfileBloc>(context).add(OnNameChanged(newName as String));
                                  }
                                },
                              ),
                            ],
                          ),
                          state.pageState == PageState.loading || state.pageState == PageState.initial
                              ? const ShimmerRectangle(size: Size(94, 21))
                              : Text(
                                  state.profile?.statusString.i18n ?? '',
                                  style: Theme.of(context).textTheme.headline7LowEmphasis,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }
}
