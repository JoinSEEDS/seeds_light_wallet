import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/components/shimmer_circle.dart';
import 'package:seeds/components/shimmer_rectangle.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/edit_profile_pic_bottom_sheet/edit_profile_pic_bottom_sheet.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

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
                            builder: (_) => const EditProfilePicBottomSheet(),
                          );
                          if (file != null) {
                            // ignore: use_build_context_synchronously
                            BlocProvider.of<ProfileBloc>(context).add(OnUpdateProfileImage(file as File));
                          }
                        },
                        child: state.showShimmer
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
                          if (state.showShimmer)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: ShimmerRectangle(size: Size(154, 30)),
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    state.profile?.nickname ?? '',
                                    style: Theme.of(context).textTheme.button1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () async {
                                    final newName =
                                        await NavigationService.of(context).navigateTo(Routes.editName, state.profile);
                                    if (newName != null) {
                                      // ignore: use_build_context_synchronously
                                      BlocProvider.of<ProfileBloc>(context).add(OnNameChanged(newName as String));
                                    }
                                  },
                                ),
                              ],
                            ),
                          if (state.showShimmer)
                            const ShimmerRectangle(size: Size(94, 21))
                          else
                            Text(
                              state.accountStatus.i18n,
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
